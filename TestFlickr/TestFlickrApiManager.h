//
//  TestFlickrApiManager.h
//  TestFlickr
//
//  Created by Anshul on 5/22/14.
//  Copyright (c) 2014 Anshul. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CallBack)(BOOL response, id result);

@interface TestFlickrApiManager : NSObject

+(void)getDataFromFlickrApiWithCallBack:(CallBack)callBack;

@end
