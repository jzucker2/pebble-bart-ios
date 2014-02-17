//
//  Pebble.m
//  PebbleBart
//
//  Created by Jordan Zucker on 2/16/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import "Pebble.h"
#import <PebbleKit/PebbleKit.h>

@interface Pebble () <PBPebbleCentralDelegate>

- (void)setTargetWatch:(PBWatch *)watch;


@end

@implementation Pebble
{
    PBWatch *_targetWatch;
}

typedef enum {
    MINUTES_KEY,
    NAME_KEY,
    DIRECTION_KEY,
    APPEND_KEY,
    DELETE_KEY,
    FETCH_KEY,
    RESET_KEY
} PebbleDictKeys;

+ (instancetype)sharedInstance {
    static Pebble *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        //sharedMyManager.stations = [[NSMutableDictionary alloc] init];
    });
    return sharedMyManager;
}

- (void) setUp
{
    // We'd like to get called when Pebbles connect and disconnect, so become the delegate of PBPebbleCentral:
    [[PBPebbleCentral defaultCentral] setDelegate:self];
    
    // Initialize with the last connected watch:
    [self setTargetWatch:[[PBPebbleCentral defaultCentral] lastConnectedWatch]];
    
    id updateHandler = [_targetWatch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
        NSLog(@"update is %@", update);
        return YES;
    }];
    NSLog(@"updateHandler is %@", updateHandler);
}

- (void) setTargetWatch:(PBWatch *)watch
{
    _targetWatch = watch;
    
    // NOTE:
    // For demonstration purposes, we start communicating with the watch immediately upon connection,
    // because we are calling -appMessagesGetIsSupported: here, which implicitely opens the communication session.
    // Real world apps should communicate only if the user is actively using the app, because there
    // is one communication session that is shared between all 3rd party iOS apps.
    
    // Test if the Pebble's firmware supports AppMessages / Weather:
    [_targetWatch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        if (isAppMessagesSupported) {
            // Configure our communications channel to target the weather app:
            // See demos/feature_app_messages/weather.c in the native watch app SDK for the same definition on the watch's end:
            //uint8_t bytes[] = {0x28, 0xAF, 0x3D, 0xC7, 0xE4, 0x0D, 0x49, 0x0F, 0xBE, 0xF2, 0x29, 0x54, 0x8C, 0x8B, 0x06, 0x00};
            //de 9b ee 97-9e 8b-40 9b-a0 dd-46 36 92 4a 43 6b
            uint8_t bytes[] = {0xDE, 0x9B, 0xEE, 0x97, 0x9E, 0x8B, 0x40, 0x9B, 0xA0, 0xDD, 0x46, 0x36, 0x92, 0x4A, 0x43, 0x6B};
            NSData *uuid = [NSData dataWithBytes:bytes length:sizeof(bytes)];
            [[PBPebbleCentral defaultCentral] setAppUUID:uuid];
            
            NSString *message = [NSString stringWithFormat:@"Yay! %@ supports AppMessages :D", [watch name]];
            [[[UIAlertView alloc] initWithTitle:@"Connected!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            
            NSString *message = [NSString stringWithFormat:@"Blegh... %@ does NOT support AppMessages :'(", [watch name]];
            [[[UIAlertView alloc] initWithTitle:@"Connected..." message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (void) sendDictToPhone:(NSDictionary *)dict
{
    if (_targetWatch == nil || [_targetWatch isConnected] == NO) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"No connected watch!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    //NSDictionary *update = @{ minutesKey:[NSString stringWithFormat:@"%ld", (long)estimate.minutes]};
    //NSDictionary *appendUpdate = @{appendKey: update};
    NSLog(@"dict to send is %@", dict);
    [_targetWatch appMessagesPushUpdate:dict onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        //message = error ? [error localizedDescription] : @"Update sent!";
        if (error != nil) {
            NSLog(@"error");
            NSLog(@"update dict that failed: %@", update);
            NSLog(@" error => %@ ", [error localizedDescription]);
            NSLog(@"localizedFailureReason => %@", [error localizedFailureReason]);
            NSLog(@"code => %ld", (long)[error code]);
            
            NSLog(@"domain => %@", [error domain]);
            NSLog(@"userInfo => %@", [error userInfo]);
            
            
        }
        //showAlert();
        NSLog(@"tried to send");
    }];
}

- (void) sendResetTrigger
{
    NSNumber *resetKey = @(RESET_KEY);
    NSDictionary *resetDict = @{resetKey: @(0)};
    [self sendDictToPhone:resetDict];
}

#pragma mark - PBPebbleCentral delegate methods

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
    [self setTargetWatch:watch];
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
    [[[UIAlertView alloc] initWithTitle:@"Disconnected!" message:[watch name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    if (_targetWatch == watch || [watch isEqual:_targetWatch]) {
        [self setTargetWatch:nil];
    }
}

- (PBWatch *)targetWatch
{
    return _targetWatch;
}



@end
