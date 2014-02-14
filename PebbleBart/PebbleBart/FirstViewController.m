//
//  FirstViewController.m
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import "FirstViewController.h"
#import "BartAPI.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _stations = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapButton:(id)sender
{
    BartAPI *bartAPI = [BartAPI sharedInstance];
    _stations = [bartAPI getStations];
}

- (IBAction)tapButton2:(id)sender
{
    BartAPI *bartAPI = [BartAPI sharedInstance];
    [bartAPI getETDForStation:[_stations objectAtIndex:0]];
}

@end
