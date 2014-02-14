//
//  BartStation.h
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import <Foundation/Foundation.h>

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

- (instancetype) initWithDictionary:(NSDictionary *)info;

@end
