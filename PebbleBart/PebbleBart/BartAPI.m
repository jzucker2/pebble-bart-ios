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

@implementation BartAPI

+ (instancetype)sharedInstance {
    static BartAPI *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (NSMutableArray *) getStations
{
    __block NSMutableArray *stationArray = [[NSMutableArray alloc] init];
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
        
        //NSMutableArray *stationArray = [[NSMutableArray alloc] init];
        for (CXMLElement *node in stations) {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            int counter;
            for(counter = 0; counter < [node childCount]; counter++) {
                //  common procedure: dictionary with keys/values from XML node
                [item setObject:[[node childAtIndex:counter] stringValue] forKey:[[node childAtIndex:counter] name]];
            }
            
            [stationArray addObject:[[BartStation alloc] initWithDictionary:item]];
        }
        
        NSLog(@"stationArray is %@", stationArray);
        for (BartStation *station in stationArray) {
            NSLog(@"%@", [station description]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    return stationArray;
}

- (void) getETDForStation:(BartStation *)station
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
                }else
                {
                    [item setValue:[childNode stringValue] forKey:[childNode name]];
                }
                
            }
        }
        NSLog(@"etdArray is %@", etdArray);
        
//        NSLog(@"stationArray is %@", stationArray);
//        for (BartStation *station in stationArray) {
//            NSLog(@"%@", [station description]);
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
