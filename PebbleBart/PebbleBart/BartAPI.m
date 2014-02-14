//
//  BartAPI.m
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import "BartAPI.h"
#import <AFNetworking.h>
#import <TouchXML.h>

@implementation BartAPI

+ (instancetype)sharedInstance {
    static BartAPI *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void) getStations
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    //manager.responseSerializer = [AFHTTPResponseSerializer new];
    [manager GET:@"http://api.bart.gov/api/stn.aspx?cmd=stns&key=MW9S-E7SL-26DU-VV8V" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"XML: %@", responseObject);
//        NSXMLParser *parser = responseObject;
        NSData * data = operation.responseData;
        //NSString *xmlString = [NSString stringWithUTF8String:[data bytes]];
        NSString *xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"-------------------------------");
        //NSLog(@"Response string: %@", xmlString);
        //NSLog(@"+++++++++++++++++++++++++++++++");
        CXMLDocument *doc = [[CXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
        NSArray *stations = [doc nodesForXPath:@"//stations/station" error:nil];
        NSLog(@"stations is %@", stations);
        NSLog(@"-------------------------------");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
