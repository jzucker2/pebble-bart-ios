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
#import "BartStation.h"
#import "BartEstimate.h"

@implementation BartAPI

+ (instancetype)sharedInstance {
    static BartAPI *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.stations = [[NSMutableDictionary alloc] init];
    });
    return sharedMyManager;
}

- (void) getStations
{
    //__block NSMutableArray *stationArray = [[NSMutableArray alloc] init];
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
        NSArray *stationsraw = [doc nodesForXPath:@"//stations/station" error:nil];
        NSLog(@"stations is %@", stationsraw);
        NSLog(@"-------------------------------");
        
        //NSMutableArray *stationArray = [[NSMutableArray alloc] init];
        for (CXMLElement *node in stationsraw) {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            int counter;
            for(counter = 0; counter < [node childCount]; counter++) {
                //  common procedure: dictionary with keys/values from XML node
                [item setObject:[[node childAtIndex:counter] stringValue] forKey:[[node childAtIndex:counter] name]];
            }
            
            BartStation *station = [[BartStation alloc] initWithDictionary:item];
            //[stationArray addObject:station];
            [_stations setValue:station forKey:station.abbr];
            NSLog(@"%@", [station description]);
        }
        
//        NSLog(@"stationArray is %@", stationArray);
//        for (BartStation *station in stationArray) {
//            NSLog(@"%@", [station description]);
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    //return stationArray;
}

- (void) getETDsForStation:(BartStation *)station
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    //manager.responseSerializer = [AFHTTPResponseSerializer new];
    NSString *getString = [NSString stringWithFormat:@"http://api.bart.gov/api/etd.aspx?cmd=etd&orig=%@&key=MW9S-E7SL-26DU-VV8V", station.abbr];
    [manager GET:getString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"XML: %@", responseObject);
        //        NSXMLParser *parser = responseObject;
        NSData * data = operation.responseData;
        //NSString *xmlString = [NSString stringWithUTF8String:[data bytes]];
        NSString *xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"-------------------------------");
        //NSLog(@"Response string: %@", xmlString);
        //NSLog(@"+++++++++++++++++++++++++++++++");
        CXMLDocument *doc = [[CXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
        NSArray *etds = [doc nodesForXPath:@"//station/etd" error:nil];
        NSLog(@"etds is %@", etds);
        NSLog(@"-------------------------------");
        
        NSMutableArray *etdArray = [[NSMutableArray alloc] init];
        NSMutableArray *estimateArray = [[NSMutableArray alloc] init];
        for (CXMLElement *node in etds) {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            int counter;
            for(counter = 0; counter < [node childCount]; counter++) {
                //  common procedure: dictionary with keys/values from XML node
                [item setObject:[[node childAtIndex:counter] stringValue] forKey:[[node childAtIndex:counter] name]];
                
            }
            [etdArray addObject:item];
            //[stationArray addObject:[[BartStation alloc] initWithDictionary:item]];
            
            for (CXMLNode *childNode in [node children])
            {
                //   NSLog(@"count -- %d ---  %@",[childNode childCount],[childNode children]);
                
                // IF ANY CHILD NODE HAVE MULTIPLE CHILDRENS THEN DO THIS....-
                if ([childNode childCount] > 1)
                {
                    NSMutableDictionary *dicChild = [[NSMutableDictionary alloc] init];
                    for (CXMLNode *ChildItemNode in [childNode children])
                    {
                        [dicChild setValue:[ChildItemNode stringValue] forKey:[ChildItemNode name]];
                    }
                    [item setValue:dicChild forKey:[childNode name]];
                    NSLog(@"greater item is %@", item);
//                    BartEstimate *estimate = [[BartEstimate alloc] initWithOrigin:station andInfo:dicChild];
//                    [estimateArray addObject:estimate];
                }else
                {
                    NSLog(@"normal item is %@", item);
                    [item setValue:[childNode stringValue] forKey:[childNode name]];
                }
//                BartEstimate *estimate = [[BartEstimate alloc] initWithOrigin:station andInfo:item];
//                [estimateArray addObject:estimate];
                
            }
            for (NSDictionary *item in etdArray) {
                BartEstimate *estimate = [[BartEstimate alloc] initWithOrigin:station andInfo:item];
                [estimateArray addObject:estimate];
            }
        }
        NSLog(@"etdArray is %@", etdArray);
        
        NSLog(@"estimateArray is %@", estimateArray);
        for (BartEstimate *estimate in estimateArray) {
            NSLog(@"%@", [estimate description]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
