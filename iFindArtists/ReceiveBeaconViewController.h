//
//  BroadcastBeaconViewController.h
//  iFindArtists
//
//  Created by Rahul Sarna on 05/05/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ReceiveBeaconViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
