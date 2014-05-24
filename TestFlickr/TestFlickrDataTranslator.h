//
//  TestFlickrDataTranslator.h
//  TestFlickr
//
//  Created by Anshul on 5/24/14.
//  Copyright (c) 2014 Anshul. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultBlock)(id parseData);
@interface TestFlickrDataTranslator : NSObject

-(void)parseDataFlickrApi:(NSDictionary *)jsonDict withCallBack:(ResultBlock)callback;

-(void)sortArrayByTitle:(NSArray *)array withCallBack:(ResultBlock)callback;
-(void)sortArrayByAuthor:(NSArray *)array withCallBack:(ResultBlock)callback;
-(void)sortArrayByDate:(NSArray *)array withCallBack:(ResultBlock)callback;

@end
