//
//  StationsViewController.h
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BartStation;

@interface StationsViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *stations;
@property (nonatomic, strong) NSIndexPath *selectedStationIndexPath;

- (void)refresh;
- (IBAction)pushToPhone:(id)sender;
- (IBAction)closestStation:(id)sender;

@end
