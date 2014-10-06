//
//  FlipsideViewController.h
//  iFindArtists
//
//  Created by Rahul Sarna on 20/04/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import "PhotographerCDTVC.h"

@class FlipsideViewController;

//@protocol FlipsideViewControllerDelegate
//- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
//@end

@interface FlipsideViewController : PhotographerCDTVC

//@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

@property (strong, nonatomic) NSManagedObjectContext *context;

//@property (strong, nonatomic) NSArray *photos;

@property (strong, nonatomic) NSString *check;

//- (IBAction)done:(id)sender;

@end
