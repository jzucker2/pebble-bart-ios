//
//  StationsViewController.m
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import "StationsViewController.h"
#import "BartAPI.h"
#import "BartStation.h"
#import "StationCell.h"
#import "EstimatesTableViewController.h"
#import "Pebble.h"

@interface StationsViewController () <PebbleDelegate>

- (void) updateStations;
- (void) setCheckmark:(BOOL)shouldCheck forCell:(UITableViewCell *)cell;

@end

@implementation StationsViewController

- (void) setCheckmark:(BOOL)shouldCheck forCell:(UITableViewCell *)cell
{
    if (shouldCheck) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) updateStations
{
    _stations = [[NSMutableArray alloc] init];
    _stations = [[[[BartAPI sharedInstance] stations] allKeys] copy];
}

- (void)refresh
{
    [self updateStations];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:_selectedStationIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.refreshControl endRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateStations];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    //_selectedStationIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:_selectedStationIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

    
    [[Pebble sharedInstance] setDelegate:self];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didReceivePebbleUpdate:(NSDictionary *)update fromWatch:(PBWatch *)watch
{
    if ([update objectForKey:@(FETCH_KEY)]) {
        NSLog(@"fetch!");
        BartAPI *api = [BartAPI sharedInstance];
        NSString *stationKey = [_stations objectAtIndex:_selectedStationIndexPath.row];
        BartStation *currentStation = [api.stations objectForKey:stationKey];
        //[[BartAPI sharedInstance] getETDsForStation:currentStation];
        //sleep(2);
        [currentStation pushAllEstimatesToPhone];
    }
}

- (IBAction)closestStation:(id)sender
{
    NSLog(@"closestStation");
    NSLog(@"closestStation is %@", [[BartAPI sharedInstance].closestStation description]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_stations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StationCell";
    StationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    BartStation *station = [[[BartAPI sharedInstance] stations] objectForKey:[_stations objectAtIndex:indexPath.row]];
    cell.nameLabel.text = station.name;
    
    return cell;
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

- (IBAction)pushToPhone:(id)sender
{
    BartAPI *api = [BartAPI sharedInstance];
    NSString *stationKey = [_stations objectAtIndex:_selectedStationIndexPath.row];
    BartStation *currentStation = [api.stations objectForKey:stationKey];
    //[[BartAPI sharedInstance] getETDsForStation:currentStation];
    //sleep(2);
    [currentStation pushAllEstimatesToPhone];
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"stationToEstimates"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        EstimatesTableViewController *destViewController = segue.destinationViewController;
        //destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
        BartAPI *api = [BartAPI sharedInstance];
        NSString *stationKey = [_stations objectAtIndex:indexPath.row];
        destViewController.currentStation = [api.stations objectForKey:stationKey];
        NSLog(@"transition");
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *oldSelectedCell = [self.tableView cellForRowAtIndexPath:_selectedStationIndexPath];
    //[self.tableView deselectRowAtIndexPath:_selectedStationIndexPath animated:YES];
    //[self setCheckmark:NO forCell:oldSelectedCell];
    _selectedStationIndexPath = indexPath;
    NSString *stationName = [_stations objectAtIndex:_selectedStationIndexPath.row];
    //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_selectedStationIndexPath];
    //[self setCheckmark:YES forCell:cell];
    
    NSLog(@"station is %@", stationName);
    BartStation *station = [[[BartAPI sharedInstance] stations] objectForKey:stationName];
    NSLog(@"%@", [station description]);
    [[BartAPI sharedInstance] getETDsForStation:station];
    
}

@end
