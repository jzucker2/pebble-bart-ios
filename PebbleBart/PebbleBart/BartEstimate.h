//
//  BartEstimate.h
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BartStation;

@interface BartEstimate : NSObject

@property (nonatomic, strong) BartStation *origin;
@property (nonatomic, strong) BartStation *destination;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *direction;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSInteger minutes;
@property (nonatomic, assign) NSInteger platform;

- (instancetype) initWithOrigin:(BartStation *)originStation andInfo:(NSDictionary *)info;

- (void) pushToPhone;

@end
