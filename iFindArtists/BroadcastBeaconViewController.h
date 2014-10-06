//
//  BeaconViewController.h
//  iFindArtists
//
//  Created by Rahul Sarna on 05/05/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BroadcastBeaconViewController : UIViewController<CBPeripheralManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) NSDictionary *myBeaconData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

@end
