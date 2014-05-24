//
//  TestFlickrDataTranslator.m
//  TestFlickr
//
//  Created by Anshul on 5/24/14.
//  Copyright (c) 2014 Anshul. All rights reserved.
//

#import "TestFlickrDataTranslator.h"
#import "FlickrInfo.h"

@implementation TestFlickrDataTranslator

-(void)parseDataFlickrApi:(NSDictionary *)jsonDict withCallBack:(ResultBlock)callbak; {
    
    NSMutableArray *flickrInfoArray = [NSMutableArray array];
    NSArray *itemsInFlickr = [jsonDict objectForKey:@"items"];
    
    for (int i =0 ; i < [itemsInFlickr count]; i++) {
       
        FlickrInfo *flickrInfo = [[FlickrInfo alloc] init];
      
        flickrInfo.title = [self isObjectNilOrNull:[[itemsInFlickr objectAtIndex:i] objectForKey:@"title"]]?@"N/A":[[itemsInFlickr objectAtIndex:i] objectForKey:@"title"];
    
        flickrInfo.author = [self isObjectNilOrNull:[[itemsInFlickr objectAtIndex:i] objectForKey:@"author"]]?@"N/A":[[itemsInFlickr objectAtIndex:i] objectForKey:@"author"];
        

        flickrInfo.date = [self convertDateIntoString:[[itemsInFlickr objectAtIndex:i] objectForKey:@"date_taken"]];
      
        flickrInfo.urlLink = [self isObjectNilOrNull:[[[itemsInFlickr objectAtIndex:i] objectForKey:@"media"] objectForKey:@"m"]]?@"N/A":[[[itemsInFlickr objectAtIndex:i] objectForKey:@"media"] objectForKey:@"m"];
       
        flickrInfo.description = [self isObjectNilOrNull:[[itemsInFlickr objectAtIndex:i] objectForKey:@"description"]]?@"N/A":[[itemsInFlickr objectAtIndex:i] objectForKey:@"description"];
        
        flickrInfo.link = [self isObjectNilOrNull:[[itemsInFlickr objectAtIndex:i] objectForKey:@"link"]]?@"N/A":[[itemsInFlickr objectAtIndex:i] objectForKey:@"link"];
        
        flickrInfo.tags = [self isObjectNilOrNull:[[itemsInFlickr objectAtIndex:i] objectForKey:@"tags"]]?@"N/A":[[itemsInFlickr objectAtIndex:i] objectForKey:@"tags"];
        
        flickrInfo.author_id = [self isObjectNilOrNull:[[itemsInFlickr objectAtIndex:i] objectForKey:@"author_id"]]?@"N/A":[[itemsInFlickr objectAtIndex:i] objectForKey:@"author_id"];
        
        flickrInfo.timeInterval = [self convertDateIntoTimeInterval:[[itemsInFlickr objectAtIndex:i] objectForKey:@"date_taken"]];
        
        [flickrInfoArray addObject:flickrInfo];
    }
    
    callbak(flickrInfoArray);
}



-(BOOL)isObjectNilOrNull:(id)object{
    if ([object isKindOfClass:[NSNull class]] || object == nil || [object isEqualToString:@""]) {
        return YES;
    }
    else{
        return NO;
    }
    
}

-(NSTimeInterval )convertDateIntoTimeInterval:(NSString *)dateStr {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    if (dateStr == nil || [dateStr isEqualToString:@""])  {
        
        dateStr = [dateFormat stringFromDate:[NSDate date]];
    }
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
    return timeInterval;

}

-(NSString *)convertDateIntoString:(NSString *)dateStr {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
   
    if (dateStr == nil || [dateStr isEqualToString:@""])  {
        
        dateStr = [dateFormat stringFromDate:[NSDate date]];
    }
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    [dateFormat setDateFormat:@"yyyy-MMM-dd HH:mm:ss"];
    
    return [dateFormat stringFromDate:date];
}

-(void)sortArrayByTitle:(NSArray *)array  withCallBack:(ResultBlock)callback{
   
    NSSortDescriptor *descriptor =[[NSSortDescriptor alloc] initWithKey:@"title"  ascending:NO];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    callback(sortedArray);
}
-(void)sortArrayByAuthor:(NSArray *)array withCallBack:(ResultBlock)callback{
    
    NSSortDescriptor *descriptor =[[NSSortDescriptor alloc] initWithKey:@"author"  ascending:NO];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    callback(sortedArray);
}
-(void)sortArrayByDate:(NSArray *)array withCallBack:(ResultBlock)callback{
    NSSortDescriptor *descriptor =[[NSSortDescriptor alloc] initWithKey:@"timeInterval"  ascending:NO];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    callback(sortedArray);
}

@end
