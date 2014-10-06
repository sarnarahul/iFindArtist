//
//  FlipsideViewController.m
//  iFindArtists
//
//  Created by Rahul Sarna on 20/04/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import "FlipsideViewController.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pull Down to Refresh" message:@"Photos Taken in This Region will be Displayed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
    [self refresh];
    
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext)
        [self useDemoDocument];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.view setNeedsDisplay];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)popView:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)useDemoDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Demo Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
                  [self refresh];
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    } else {
        self.managedObjectContext = document.managedObjectContext;
    }
}



#pragma mark - Actions

//- (IBAction)done:(id)sender
//{
//    [self.delegate flipsideViewControllerDidFinish:self];
//}

- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        
        NSArray *photos;
        if([_check isEqualToString:@"explore"])
                photos =  [FlickrFetcher searchLocation];
        else{
            photos = [FlickrFetcher loadGeoreferencedPhotos];
        }
        
        // put the photos in Core Data
        [self.managedObjectContext performBlock:^{
            for (NSDictionary *photo in photos) {
                [Photo photoWithFlickrInfo:photo inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}

@end
