//
//  TestFlickrApiManager.m
//  TestFlickr
//
//  Created by Anshul on 5/22/14.
//  Copyright (c) 2014 Anshul. All rights reserved.
//

#import "TestFlickrApiManager.h"
#define FLICKR_URL @"http://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"

@implementation TestFlickrApiManager

+(void)getDataFromFlickrApiWithCallBack:(CallBack)callBack {

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:FLICKR_URL]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSError *error = nil;
        
        if (connectionError) {
            callBack(NO,connectionError.localizedDescription);
        } else if (((NSHTTPURLResponse *)response).statusCode == 200) { //Indicates Proper Response has been Received
            
            NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSData *jsonData  = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
           
            if (error) {
                
                //If there is error in json format try to fetch saved json for demo purpose
                jsonStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"document" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
                
                jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
              
                callBack(YES,jsonDict);
                
            } else {
                if (jsonDict == nil) {
                    callBack(YES,@"NO Data To Display");
                }else {
                    callBack(YES,jsonDict);
                }
            }
        } else {
            callBack(NO,@"Error in Connection");
        }
        
    }];
}

@end
