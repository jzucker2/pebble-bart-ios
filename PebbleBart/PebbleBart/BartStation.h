//
//  BartStation.h
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class CLLocation;

@interface BartStation : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *abbr;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *county;
@property (nonatomic, strong) NSString *gtfs_latitude;
@property (nonatomic, strong) NSString *gtfs_longitude;
@property (nonatomic, strong) NSMutableArray *northEstimates;
@property (nonatomic, strong) NSMutableArray *southEstimates;

- (instancetype) initWithDictionary:(NSDictionary *)info;
- (void) pushAllEstimatesToPhone;

- (CLLocation *) location;
- (CLLocationDistance) distanceFromCurrentLocation;

//- (NSMutableArray *) northEstimates;
//- (NSMutableArray *) southEstimates;

@end
