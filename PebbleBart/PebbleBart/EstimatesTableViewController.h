//
//  EstimatesTableViewController.h
//  PebbleBart
//
//  Created by Jordan Zucker on 2/16/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BartStation;
@interface EstimatesTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *estimatesArray;
@property (nonatomic, strong) NSMutableArray *northEstimatesArray;
@property (nonatomic, strong) NSMutableArray *southEstimatesArray;
@property (nonatomic, strong) BartStation *currentStation;

- (void) refresh;
- (void) updateEstimates;

- (void) updateTable;

- (IBAction)sendToWatch:(id)sender;

@end
