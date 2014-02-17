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
#import "Pebble.h"
#import <PebbleKit/PebbleKit.h>

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

- (void) pushToPhone
{
    PBWatch *targetWatch = [Pebble sharedInstance].targetWatch;
    if (targetWatch == nil || [targetWatch isConnected] == NO) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"No connected watch!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    // Send data to watch:
    // See demos/feature_app_messages/weather.c in the native watch app SDK for the same definitions on the watch's end:
    NSNumber *minutesKey = @(0); // This is our custom-defined key for the icon ID, which is of type uint8_t.
    NSNumber *nameKey = @(1); // This is our custom-defined key for the temperature string.
    NSNumber *directionKey = @(2);
    NSNumber *appendKey = @(3);
    //NSNumber *appendKey = @(0);
    NSDictionary *update = @{ minutesKey:[NSString stringWithFormat:@"%ld minutes", (long)_minutes], nameKey:_destination.name, directionKey: _direction, appendKey: @(0)};
    //NSDictionary *update = @{ minutesKey:[NSString stringWithFormat:@"%ld", (long)estimate.minutes]};
    //NSDictionary *appendUpdate = @{appendKey: update};
    
    [targetWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        //message = error ? [error localizedDescription] : @"Update sent!";
        if (error != nil) {
            NSLog(@"error");
            NSLog(@" error => %@ ", [error localizedDescription]);
        }
        //showAlert();
        NSLog(@"tried to send");
    }];
}



@end
