//
//  Pebble.h
//  PebbleBart
//
//  Created by Jordan Zucker on 2/16/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PBWatch;
@class CLLocation;
@class CLLocationManager;

@protocol PebbleDelegate;

typedef enum {
    MINUTES_KEY,
    NAME_KEY,
    DIRECTION_KEY,
    APPEND_KEY,
    DELETE_KEY,
    FETCH_KEY,
    RESET_KEY
} PebbleDictKeys;

@interface Pebble : NSObject

//@property (nonatomic, strong) PBWatch *targetWatch;
@property (nonatomic, weak) id<PebbleDelegate>delegate;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

+ (instancetype) sharedInstance;
- (void) setUp;

- (PBWatch *) targetWatch;
- (void) sendDictToPhone:(NSDictionary *)dict;
- (void) sendResetTrigger;

@end

@protocol PebbleDelegate <NSObject>

@optional
- (void) didReceivePebbleUpdate:(NSDictionary *)update fromWatch:(PBWatch *)watch;

@end
