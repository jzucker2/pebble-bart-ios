//
//  BartStation.m
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import "BartStation.h"
#import "BartEstimate.h"
#import "Pebble.h"

@implementation BartStation

- (instancetype) initWithDictionary:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        _abbr = [info objectForKey:@"abbr"];
        _address = [info objectForKey:@"address"];
        _city = [info objectForKey:@"city"];
        _county = [info objectForKey:@"county"];
        _gtfs_latitude = [info objectForKey:@"gtfs_latitude"];
        _gtfs_longitude = [info objectForKey:@"gtfs_longitude"];
        _name = [info objectForKey:@"name"];
        _state = [info objectForKey:@"state"];
        _zipcode = [info objectForKey:@"zipcode"];
        _northEstimates = [[NSMutableArray alloc] init];
        _southEstimates = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nStation name: %@\nStation abbr: %@\nStation address: %@\nStation city: %@\nStation county: %@\nStation state: %@\nStation gtfs_latitude: %@\nStation gtfs_longitude: %@\nStation zipcode: %@", _name, _abbr, _address,_city, _county, _state, _gtfs_latitude, _gtfs_longitude, _zipcode];
}

- (void) pushAllEstimatesToPhone
{
    [[Pebble sharedInstance] sendResetTrigger];
    sleep(1);
    NSLog(@"do north estimates");
    for (BartEstimate *estimate in _northEstimates) {
        NSLog(@"estimate description is %@", [estimate description]);
        sleep(1);
        [estimate pushToPhone];
        //[estimate performSelector:@selector(pushToPhone) withObject:nil afterDelay:1];
    }
    NSLog(@"now do south estimates");
    for (BartEstimate *estimate in _southEstimates) {
        NSLog(@"estimate description is %@", [estimate description]);
        sleep(1);
        [estimate pushToPhone];
        //[estimate performSelector:@selector(pushToPhone) withObject:nil afterDelay:1];
    }
}

//- (NSMutableArray *) northEstimates
//{
//    
//}
//
//- (NSMutableArray *) southEstimates
//{
//    
//}

@end
