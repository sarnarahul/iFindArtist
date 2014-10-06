//
//

#import "PhotosByPhotographerCDTVC.h"
#import "Photo.h"
#import "AGPhotoBrowserView.h"

@interface PhotosByPhotographerCDTVC ()<AGPhotoBrowserDelegate, AGPhotoBrowserDataSource>{
    
    NSMutableArray *imageArray;
    NSInteger currentIndex;
}


@property (nonatomic, strong) AGPhotoBrowserView *browserView;

@end

@implementation PhotosByPhotographerCDTVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    imageArray = [[NSMutableArray alloc] init];
}

#pragma mark - Properties

// When our Model is set here, we update our title to be the Photographer's name
//   and then set up our NSFetchedResultsController to make a request for Photos taken by that Photographer.

- (void)setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;
    [self setupFetchedResultsController];
}

// Creates an NSFetchRequest for Photos sorted by their title where the whoTook relationship = our Model.
// Note that we have the NSManagedObjectContext we need by asking our Model (the Photographer) for it.
// Uses that to build and set our NSFetchedResultsController property inherited from CoreDataTableViewController.

- (void)setupFetchedResultsController
{
    if (self.photographer.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", self.photographer];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.photographer.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[self.browserView showFromIndex:indexPath.row];
}

#pragma mark - AGPhotoBrowser delegate

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton
{
	// -- Dismiss
	NSLog(@"Dismiss the photo browser here");
	[self.browserView hideWithCompletion:^(BOOL finished){
		NSLog(@"Dismissed!");
	}];
}

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnActionButton:(UIButton *)actionButton atIndex:(NSInteger)index
{
	NSLog(@"Action button tapped at index %ld!", (long)index);
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@""
														delegate:self
											   cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel button")
										  destructiveButtonTitle:nil
											   otherButtonTitles:NSLocalizedString(@"Share", @"Share button"), nil];
	[action showInView:self.view];
}


#pragma mark - Getters

- (AGPhotoBrowserView *)browserView
{
	if (!_browserView) {
		_browserView = [[AGPhotoBrowserView alloc] initWithFrame:CGRectZero];
		_browserView.delegate = self;
        _browserView.dataSource = self;
	}
	
	return _browserView;
}

#pragma mark - AGPhotoBrowser datasource

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
{
	return [self.fetchedResultsController.fetchedObjects count];
}

- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index
{
    NSURL *url = [NSURL URLWithString:[[self.fetchedResultsController.fetchedObjects objectAtIndex:index] imageURL]];
    
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    NSLog(@"%@",img);
    
	return img;
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser titleForImageAtIndex:(NSInteger)index
{
    Photo *photo = [self.fetchedResultsController.fetchedObjects objectAtIndex:index];
    
    NSString *title = photo.title;

	return title;
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser descriptionForImageAtIndex:(NSInteger)index
{
    
    Photo *photo = [self.fetchedResultsController.fetchedObjects objectAtIndex:index];
    
	return photo.subtitle;
}

- (BOOL)photoBrowser:(AGPhotoBrowserView *)photoBrowser willDisplayActionButtonAtIndex:(NSInteger)index
{
    currentIndex = index;
    
    return YES;
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
            switch (buttonIndex) {
                case 0:
                   [self shareImage];
                    break;
                
                default:
                    break;
            }

}

-(void) shareImage{
    
    NSString *textToShare = @"iFindArtists Found me an Artist";
    UIImage *imageToShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.fetchedResultsController.fetchedObjects objectAtIndex:currentIndex]imageURL]]] ];
    NSArray *itemsToShare = @[textToShare, imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
//    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    
    [_browserView hideWithCompletion:nil];
    
    
    [self presentViewController:activityVC animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

// Loads up the cell for a given row by getting the associated Photo from our NSFetchedResultsController.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.photoTitle.text = photo.title;
    cell.photoSubtitle.text = photo.subtitle;
    
    NSURL *url = [NSURL URLWithString:[photo imageURL]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.photoImageView.image = image;
        });
    });

        
    

    
    return cell;
    
}

@end
