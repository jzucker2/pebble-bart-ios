//
//  BartEstimate.m
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import "BartEstimate.h"
#import "BartStation.h"

@implementation BartEstimate

- (instancetype) initWithOrigin:(BartStation *)originStation andInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        _origin = originStation;
        _color = [info objectForKey:@"color"];
        _direction = [info objectForKey:@"direction"];
        _length = [[info objectForKey:@"length"] integerValue];
        _minutes = [[info objectForKey:@"minutes"] integerValue];
        _platform = [[info objectForKey:@"platform"] integerValue];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nEstimate origin: %@\nEstimate destination: %@\nEstimate direction: %@\nEstimate length: %d\nEstimate minutes: %d\nEstimate platform: %d", _origin.name, _destination.name, _direction, _length, _minutes, _platform];
}



@end
