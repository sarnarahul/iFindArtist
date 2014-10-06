//
//  FlickrFetcher.m
//

#import "FlickrFetcher.h"
#import "FlickrAPIKey.h"

#define FLICKR_PLACE_ID @"place_id"

//https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b1b32c81a332014025dc13b4b493995d&text=stony+brook&format=rest

@implementation FlickrFetcher


+ (NSDictionary *)executeFlickrFetch:(NSString *)query
{
    query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key=%@", query, FlickrAPIKey];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (NSLOG_FLICKR) NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    [NSThread sleepForTimeInterval:2.0];
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    if (NSLOG_FLICKR) NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    
//    NSLog(@"%@",results);
    
    return results;
}

+ (NSArray *)topPlaces
{
    NSString *request = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.places.getTopPlacesList&place_type_id=7"];
    return [[self executeFlickrFetch:request] valueForKeyPath:@"places.place"];
}

+ (NSArray *)stanfordPhotos
{
    NSString *request = @"https://api.flickr.com/services/rest/?user_id=48247111@N07&format=json&nojsoncallback=1&extras=original_format,tags,description,geo,date_upload,owner_name&page=1&method=flickr.photos.search";
    return [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
}

+ (NSArray *)search: (NSString *)term
{
    NSString *request = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?format=json&nojsoncallback=1&extras=original_format,tags,safe_search=1,sort=interestingness-desc,description,geo,date_upload,owner_name&page=1&text=%@&method=flickr.photos.search",term];
    return [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
}



+ (NSArray *)stonyBrookPhotos
{
    NSString *request = @"https://api.flickr.com/services/rest/?user_id=920958@N25&format=json&nojsoncallback=1&extras=original_format,tags,description,geo,date_upload,owner_name&page=1&method=flickr.photos.search";
    return [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
}

//920958@N25

+ (NSArray *)photosInPlace:(NSDictionary *)place maxResults:(int)maxResults
{
    NSArray *photos = nil;
    NSString *placeId = [place objectForKey:FLICKR_PLACE_ID];
    if (placeId) {
        NSString *request = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&place_id=%@&per_page=%d&extras=original_format,tags,description,geo,date_upload,owner_name,place_url", placeId, maxResults];
        NSString *placeName = [place objectForKey:FLICKR_PLACE_NAME];
        photos = [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
        for (NSMutableDictionary *photo in photos) {
            [photo setObject:placeName forKey:FLICKR_PHOTO_PLACE_NAME];
        }
    }
    return photos;
}

+(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%f,%f&output=csv",pdblLatitude, pdblLongitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    // NSLog(@"%@",locationString);
    
    locationString = [locationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return [locationString substringFromIndex:6];
}

+ (NSArray *)searchLocation
{
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    NSLog(@"GPS Location is initialised...");
    
    
    return [self search:[self getAddressFromLatLon:locationManager.location.coordinate.latitude withLongitude:locationManager.location.coordinate.longitude]];
}

+ (NSArray *)latestGeoreferencedPhotos
{
    NSString *request = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&per_page=500&license=1,2,4,7&has_geo=1&extras=original_format,tags,description,geo,date_upload,owner_name,place_url"];
    return [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
}

+ (NSArray *)loadGeoreferencedPhotos
{
    NSString *request = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&per_page=20&page=1&license=1,2,4,7&has_geo=1&extras=original_format,tags,description,geo,date_upload,owner_name,place_url"];
    return [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
}

+ (NSString *)urlStringForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format
{
	id farm = [photo objectForKey:@"farm"];
	id server = [photo objectForKey:@"server"];
	id photo_id = [photo objectForKey:@"id"];
	id secret = [photo objectForKey:@"secret"];
	if (format == FlickrPhotoFormatOriginal) secret = [photo objectForKey:@"originalsecret"];
    
	NSString *fileType = @"jpg";
	if (format == FlickrPhotoFormatOriginal) fileType = [photo objectForKey:@"originalformat"];
	
	if (!farm || !server || !photo_id || !secret) return nil;
	
	NSString *formatString = @"s";
	switch (format) {
		case FlickrPhotoFormatSquare:    formatString = @"s"; break;
		case FlickrPhotoFormatLarge:     formatString = @"b"; break;
		// case FlickrPhotoFormatThumbnail: formatString = @"t"; break;
		// case FlickrPhotoFormatSmall:     formatString = @"m"; break;
		// case FlickrPhotoFormatMedium500: formatString = @"-"; break;
		// case FlickrPhotoFormatMedium640: formatString = @"z"; break;
		case FlickrPhotoFormatOriginal:  formatString = @"o"; break;
	}
    
	return [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_%@.%@", farm, server, photo_id, secret, formatString, fileType];
}

+ (NSURL *)urlForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format
{
    return [NSURL URLWithString:[self urlStringForPhoto:photo format:format]];
}

@end
