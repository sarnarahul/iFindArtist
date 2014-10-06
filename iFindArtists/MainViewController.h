//
//  MainViewController.h
//  iFindArtists
//
//  Created by Rahul Sarna on 20/04/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import "FlipsideViewController.h"
#import "FlickrFetcher.h"

#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController<UITextFieldDelegate>
//<FlipsideViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

@property (strong, nonatomic) IBOutlet UIButton *exploreButton;

@property (strong, nonatomic) IBOutlet UIButton *findArtistButton;

@property (strong, nonatomic) IBOutlet UIButton *broadcastButton;

@property (strong, nonatomic) IBOutlet UITextField *searchText;

@property (strong, nonatomic) UIView *exploreButtonView;

@end
