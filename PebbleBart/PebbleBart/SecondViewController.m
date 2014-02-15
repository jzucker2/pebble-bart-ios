//
//  SecondViewController.m
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import "SecondViewController.h"
#import <PebbleKit/PebbleKit.h>

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pebble:(id)sender
{
    //[[PBPebbleCentral defaultCentral] setDelegate:self];
    PBWatch *watch = [[PBPebbleCentral defaultCentral] lastConnectedWatch];
    NSLog(@"watch is %@", watch);
    
}

@end
