//
//  BeaconViewController.m
//  iFindArtists
//
//  Created by Rahul Sarna on 05/05/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import "BroadcastBeaconViewController.h"

@interface BroadcastBeaconViewController ()

@end

@implementation BroadcastBeaconViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Create NSUUID object
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"41A6912D-7DBC-4752-A404-E8E6131F95AA"];
    
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 minor:1 identifier:@"com.autokrat.testregion"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)broadcastButton:(id)sender {
    
    //get beacon data
    self.myBeaconData = [self.myBeaconRegion peripheralDataWithMeasuredPower:nil];
    
    //start the peripheral manager
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager*)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        // Bluetooth is on
        
        // Update our status label
        self.statusLabel.text = @"Broadcasting...";
        
        // Start broadcasting
        [self.peripheralManager startAdvertising:self.myBeaconData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        // Update our status label
        self.statusLabel.text = @"Stopped";
        
        // Bluetooth isn't on. Stop broadcasting
        [self.peripheralManager stopAdvertising];
    }
    else if (peripheral.state == CBPeripheralManagerStateUnsupported)
    {
        self.statusLabel.text = @"Unsupported";
    }
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
