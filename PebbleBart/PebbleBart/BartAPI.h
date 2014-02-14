//
//  BartAPI.h
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BartStation;

@interface BartAPI : NSObject

@property (nonatomic, strong) NSMutableDictionary *stations;

+ (instancetype) sharedInstance;
- (NSMutableArray *) getStations;
- (void) getETDForStation:(BartStation *)station;

@end
