//
//  SearchViewController.m
//  iFindArtists
//
//  Created by Rahul Sarna on 05/05/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import "SearchViewController.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "Photo.h"

@interface SearchViewController ()
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

    [self loadLoginPhotos];
        
    });
    
    _backButton.backgroundColor = [UIColor colorWithRed:0.825 green:0.841 blue:1.0 alpha:1.0];
    
    [_backButton setTitle:@"Menu" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1.0] forState:UIControlStateNormal];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) loadLoginPhotos{
    
    
    NSArray *photos = [FlickrFetcher search:_searchText];
    
    // put the photos in Core Data
    
    for (NSDictionary *photo in photos ) {
        
        
        NSURL *photoURL = [[FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge] absoluteURL];
        
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(160, 240);
        spinner.hidesWhenStopped = YES;
        [self.view addSubview:spinner];
        [spinner startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self addImageToView:image];
                [spinner stopAnimating];
            });
        });
    }
    
    
}

static UIImage *myImage;

- (void) addImageToView:(UIImage *)image {
    
    //    NSData *dataForPNGFile = UIImagePNGRepresentation(image);
    
    //	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:dataForPNGFile]];
	
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    imageView.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *rightLongPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    
    [imageView addGestureRecognizer:rightLongPressRecognizer];
    
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

-(void) handleLongPress: (UILongPressGestureRecognizer *) sender{
    

        CGPoint location = [sender locationInView: sender.view];
        UIView *viewHit = [sender.view hitTest:location withEvent:NULL];
//        NSLog(@"%@ <-> %@", [viewHit class],sender.view);
    

            NSLog(@"ImageViewTapped!");
            NSString *textToShare = @"iFindArtists Found me an Artist";
            UIImage *imageToShare = ((UIImageView *)viewHit).image;
            NSArray *itemsToShare = @[textToShare, imageToShare];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
            //    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    
            [self presentViewController:activityVC animated:YES completion:nil];
    
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
