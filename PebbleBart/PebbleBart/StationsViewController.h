//
//  StationsViewController.h
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationsViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *stations;

- (IBAction)refresh:(id)sender;

@end
