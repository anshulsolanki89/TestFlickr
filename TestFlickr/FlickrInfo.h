//
//  FlcikrInfo.h
//  TestFlickr
//
//  Created by Anshul on 5/24/14.
//  Copyright (c) 2014 Anshul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrInfo : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *urlLink;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSString *tags;
@property (nonatomic,strong) NSString *author_id;
@property (nonatomic,assign) NSTimeInterval timeInterval;
@end
