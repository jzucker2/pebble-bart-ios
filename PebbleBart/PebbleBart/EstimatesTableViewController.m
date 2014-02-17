//
//  EstimatesTableViewController.m
//  PebbleBart
//
//  Created by Jordan Zucker on 2/16/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import "EstimatesTableViewController.h"
#import "EstimateCell.h"
#import "BartEstimate.h"
#import "BartStation.h"
#import "BartAPI.h"
#import <PebbleKit.h>
#import "AppDelegate.h"

@interface EstimatesTableViewController ()

@end

@implementation EstimatesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) updateEstimates
{
    [[BartAPI sharedInstance] getETDsForStation:_currentStation];
    _northEstimatesArray = _currentStation.northEstimates;
    _southEstimatesArray = _currentStation.southEstimates;
    //_northEstimatesArray =
    
}

- (void) updateTable
{
    [self.tableView reloadData];
}

- (void)refresh
{
    //[self updateStations];
    [self updateEstimates];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _currentStation.name;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _northEstimatesArray = [[NSMutableArray alloc] init];
    _southEstimatesArray = [[NSMutableArray alloc] init];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"finishedGettingEstimates" object:nil];
    
    [self updateEstimates];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"finishedGettingEstimates" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"North";
        case 1:
            return @"South";
            
        default:
            break;
    }
    return @"Hey";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [_northEstimatesArray count];
        case 1:
            return [_southEstimatesArray count];
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EstimateCell";
    EstimateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    BartEstimate *estimate;
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
        {
            estimate = [_northEstimatesArray objectAtIndex:indexPath.row];
        }
            break;
        case 1:
        {
            estimate = [_southEstimatesArray objectAtIndex:indexPath.row];
            
        }
            break;
            
        default:
            break;
    }
    
    cell.destinationLabel.text = estimate.destination.name;
    cell.minutesLabel.text = [NSString stringWithFormat:@"%ld", (long)estimate.minutes];
    
    return cell;
}

- (IBAction)sendToWatch:(id)sender
{
    [_currentStation pushAllEstimatesToPhone];
//    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
//    BartEstimate *estimate;
//    switch (selectedIndexPath.section) {
//        case 0:
//        {
//            estimate = [_northEstimatesArray objectAtIndex:selectedIndexPath.row];
//        }
//            break;
//        case 1:
//        {
//            estimate = [_southEstimatesArray objectAtIndex:selectedIndexPath.row];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    [estimate pushToPhone];
    

    
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    PBWatch *targetWatch = appDelegate.targetWatch;
//    if (targetWatch == nil || [targetWatch isConnected] == NO) {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"No connected watch!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//        return;
//    }
//    
//    // Send data to watch:
//    // See demos/feature_app_messages/weather.c in the native watch app SDK for the same definitions on the watch's end:
//    NSNumber *minutesKey = @(0); // This is our custom-defined key for the icon ID, which is of type uint8_t.
//    NSNumber *nameKey = @(1); // This is our custom-defined key for the temperature string.
//    NSNumber *directionKey = @(2);
//    NSNumber *appendKey = @(3);
//    //NSNumber *appendKey = @(0);
//    NSDictionary *update = @{ minutesKey:[NSString stringWithFormat:@"%ld", (long)estimate.minutes], nameKey:estimate.destination.name, directionKey: estimate.direction, appendKey: @(0)};
//    //NSDictionary *update = @{ minutesKey:[NSString stringWithFormat:@"%ld", (long)estimate.minutes]};
//    //NSDictionary *appendUpdate = @{appendKey: update};
//    
//    [targetWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
//        //message = error ? [error localizedDescription] : @"Update sent!";
//        if (error != nil) {
//            NSLog(@"error");
//            NSLog(@" error => %@ ", [error localizedDescription]);
//        }
//        //showAlert();
//        NSLog(@"tried to send");
//    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
