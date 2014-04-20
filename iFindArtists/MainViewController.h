//
//  MainViewController.h
//  iFindArtists
//
//  Created by Rahul Sarna on 20/04/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
