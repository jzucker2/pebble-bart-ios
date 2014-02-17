//
//  BartAPI.h
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class BartStation;

@interface BartAPI : NSObject

@property (nonatomic, strong) NSMutableDictionary *stations;
@property (nonatomic, strong) BartStation *closestStation;
@property (nonatomic, assign) CLLocationDistance closestStationDistance;
@property (nonatomic, strong) BartStation *selectedStation;

+ (instancetype) sharedInstance;
- (void) getStations;
- (void) getETDsForStation:(BartStation *)station;

@end
