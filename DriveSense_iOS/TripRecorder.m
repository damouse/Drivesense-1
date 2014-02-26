//
//  TripRecorder.m
//  DriveSense_iOS
//
//  Created by Mickey Barboi on 2/23/14.
//  Copyright (c) 2014 Mickey Barboi. All rights reserved.
//

#import "TripRecorder.h"

@implementation TripRecorder {
    BOOL recording;
    CLLocationManager *locationManager;
    
    //used to remember what the last reported coordinate was so we can accurately
    //close out a trip. See stopRecording method
    CLLocation *lastReceivedLocation;
}

+ (id)recorder {
    static TripRecorder *recorder = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        recorder = [[self alloc] init];
    });
    return recorder;
}

- (id)init {
    if (self = [super init]) {
        recording = NO;
        locationManager = [[CLLocationManager alloc] init];
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 1; // meters
    }
    return self;
}


#pragma mark Recording Methods
- (BOOL) startRecording {
    //start collecting data
    [locationManager startUpdatingLocation];
    return YES;
}

- (BOOL) stopRecording {
    //stop collecting data. Ensure that this is a valid time to do this
    [locationManager stopUpdatingLocation];
    return YES;
}


#pragma mark CLLocation Callback
// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    lastReceivedLocation = [locations objectAtIndex:0];
    
    NSLog(@"%f, %f", lastReceivedLocation.coordinate.longitude, lastReceivedLocation.coordinate.latitude);

}
@end
