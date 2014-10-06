//
//  MainViewController.m
//  iFindArtists
//
//  Created by Rahul Sarna on 20/04/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import "MainViewController.h"
#import "Photo.h"
#import "Photo+Flickr.h"
#import "AppDelegate.h"
#import "SearchViewController.h"

@interface MainViewController (){
    NSThread *workerThread;
    NSTimer  *timeoutTimer;
}
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _exploreButton.backgroundColor = [UIColor colorWithRed:0.825 green:0.841 blue:1.0 alpha:1.0];
    _findArtistButton.backgroundColor = [UIColor colorWithRed:0.825 green:0.841 blue:1.0 alpha:1.0];
    _broadcastButton.backgroundColor = [UIColor colorWithRed:0.825 green:0.841 blue:1.0 alpha:1.0];
    
    _searchButton.backgroundColor = [UIColor colorWithRed:0.825 green:0.841 blue:1.0 alpha:1.0];
    
    _searchText.backgroundColor = [UIColor colorWithRed:0.85 green:0.4 blue:0.5 alpha:0.8];
    
    [_searchText setPlaceholder:@"SEARCH"];
    
    _searchText.delegate = self;
    
    [_searchText setText:@"Stony Brook University"];
    
    [_exploreButton setTitle:@"EXPLORE" forState:UIControlStateNormal];
    [_exploreButton setTitleColor:[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1.0] forState:UIControlStateNormal];
    [_searchButton setTitle:@"SEARCH" forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1.0] forState:UIControlStateNormal];
    
    [_findArtistButton setTitle:@"Find iBeacon Artist" forState:UIControlStateNormal];
    [_findArtistButton setTitleColor:[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1.0] forState:UIControlStateNormal];
    
    [_broadcastButton setTitle:@"Broadcast My iBeacon" forState:UIControlStateNormal];
    [_broadcastButton setTitleColor:[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1.0] forState:UIControlStateNormal];
    
    [self loadLoginPhotos];
    
    if(!self.managedObjectContext){
        self.managedObjectContext = [AppDelegate context];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
  
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

-(void) loadLoginPhotos{
    
    
    __weak NSArray *photos = [FlickrFetcher loadGeoreferencedPhotos];

    // put the photos in Core Data
    
    for (NSDictionary *photo in photos) {
                
            [Photo photoWithFlickrInfo:photo inManagedObjectContext:self.managedObjectContext];
                
               NSURL *photoURL = [[FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge] absoluteURL];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self addImageToView:image];
                    });
                });
            }
    

}

- (void) addImageToView:(UIImage *)image {
    
//    NSData *dataForPNGFile = UIImagePNGRepresentation(image);
    
//	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:dataForPNGFile]];
	
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
	CGFloat width = CGRectGetWidth(self.imageScrollView.frame);
	CGFloat imageRatio = image.size.width / image.size.height;
	CGFloat height = width / imageRatio;
	CGFloat x = 0;
	CGFloat y = self.imageScrollView.contentSize.height;
	
	imageView.frame = CGRectMake(x, y, width, height);
	
	CGFloat newHeight = self.imageScrollView.contentSize.height + height;
	self.imageScrollView.contentSize = CGSizeMake(320, newHeight);
	
	[self.imageScrollView addSubview:imageView];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Flipside View
//
//- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"explore"]) {
        [[segue destinationViewController] setDelegate:self];
        
        
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        
        FlipsideViewController *fvc = (FlipsideViewController *)[[navController viewControllers] lastObject];
        
        fvc.check = @"explore";
    }
    else if ([[segue identifier] isEqualToString:@"topPlaces"]) {
        [[segue destinationViewController] setDelegate:self];
        
        
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        
        FlipsideViewController *fvc = (FlipsideViewController *)[[navController viewControllers] lastObject];
        
        fvc.check = @"topPlaces";
    }
    else if ([[segue identifier] isEqualToString:@"search"]){
        SearchViewController *svc = (SearchViewController *)[segue destinationViewController];
        svc.searchText = _searchText.text;
    }
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    
    [textField resignFirstResponder];
    
    [self performSegueWithIdentifier:@"search" sender:self];
    
    return YES;
}


@end
