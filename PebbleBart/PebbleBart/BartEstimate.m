//
//  BartEstimate.m
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import "BartEstimate.h"
#import "BartStation.h"
#import "BartAPI.h"

@implementation BartEstimate

- (instancetype) initWithOrigin:(BartStation *)originStation andInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        _origin = originStation;
        BartAPI *bartapi = [BartAPI sharedInstance];
        _destination = [bartapi.stations objectForKey:[info objectForKey:@"abbreviation"]];
        NSDictionary *estimateInfo = [info objectForKey:@"estimate"];
        _color = [estimateInfo objectForKey:@"color"];
        _direction = [estimateInfo objectForKey:@"direction"];
        _length = [[estimateInfo objectForKey:@"length"] integerValue];
        _minutes = [[estimateInfo objectForKey:@"minutes"] integerValue];
        _platform = [[estimateInfo objectForKey:@"platform"] integerValue];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nEstimate origin: %@\nEstimate destination: %@\nEstimate direction: %@\nEstimate length: %ld\nEstimate minutes: %ld\nEstimate platform: %ld", _origin.name, _destination.name, _direction, (long)_length, (long)_minutes, (long)_platform];
}



@end
