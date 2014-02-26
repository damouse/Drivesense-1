//
//  MapRootViewController.m
//  DriveSense_iOS
//
//  Created by Mickey Barboi on 2/23/14.
//  Copyright (c) 2014 Mickey Barboi. All rights reserved.
//

#import "MapRootViewController.h"
#import "AppDelegate.h"
#import "TripRecorder.h"

@interface MapRootViewController () {
    
    //a flag to indicate the controller is currently recording
    BOOL recording;
    
    //used to save the final position of the view on the screen so we can animate to here later
    CGRect frameIn;
    
    //a counter to represent the total elapsed time
    int secondsRecording;
    
    //A timer. It calls the given method ever x seconds
    NSTimer *durationTimer;
}

@end


@implementation MapRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.navigationController.navigationBarHidden = YES;
    [mapMain setUserTrackingMode:MKUserTrackingModeFollow];
    
    //init recording to NO as a default
    recording = NO;
    [mapMain setDelegate:self];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [labelTripName setText:@"Name Placeholder"];
    
    frameIn = viewRecordingContainer.frame;
    [self animateViewOut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Buttons
- (IBAction)record:(id)sender {
    //if currently recording, pause. Toggles image currently displayed from play button to pause button
    
    //switch images
    if(recording) {
        [buttonRecord setBackgroundImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        
        //start the timer
        [self stopTimer];
        
        //don't follow the user around when not tracking
        [mapMain setUserTrackingMode:MKUserTrackingModeNone];
        
        [[TripRecorder recorder] stopRecording];
        [self animateViewOut];
    }
    else {
        [buttonRecord setBackgroundImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        
        //follow the user along when tracking
        [mapMain setUserTrackingMode:MKUserTrackingModeFollow];
        
        //stop the timer
        [self startTimer];
        
        [[TripRecorder recorder] startRecording];
        [self animateViewIn];
    }
    
    //toggle flag
    recording = !recording;
}


#pragma mark Trip Timing
- (void) incrementTimer {
    secondsRecording++;
    
    [labelDuration setText:[NSString stringWithFormat:@"%i seconds", secondsRecording]];
}

- (void) startTimer {
    //start the local instance variable timer
    durationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementTimer) userInfo:nil repeats:YES];
}

- (void) stopTimer {
    //stop the local instance variable timer
    durationTimer = nil;
}


#pragma mark Animation Methods
- (void) animateViewIn {
    [UIView animateWithDuration:0.25 animations:^{
        viewRecordingContainer.frame =  frameIn;
    }];
}

- (void) animateViewOut {
    [UIView animateWithDuration:0.25 animations:^{
        int y = self.view.frame.size.height;
        
        CGRect newFrame = frameIn;
        newFrame.origin.y = y;
        
        viewRecordingContainer.frame =  newFrame;
    }];
}
@end
