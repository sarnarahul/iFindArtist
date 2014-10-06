//
//  BroadcastBeaconViewController.m
//  iFindArtists
//
//  Created by Rahul Sarna on 05/05/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import "ReceiveBeaconViewController.h"

@interface ReceiveBeaconViewController ()

@end

@implementation ReceiveBeaconViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    // Initialize location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"41A6912D-7DBC-4752-A404-E8E6131F95AA"];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                             identifier:@"com.appcoda.testregion"];
    
    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
    self.statusLabel.text = @"No";
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    self.statusLabel.text = @"Photographer Nearby!";
    
//    CLBeacon *foundBeacon = [beacons firstObject];
    
    // You can retrieve the beacon data from its properties
    //NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    //NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
    //NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
}
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
