//
//  DataManager.h
//  QrcodeSms
//
//  Created by ZongDa on 3/6/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
{
    BOOL            _loadingFlag;
    NSMutableArray *_eventArray;
    NSMutableArray *_imageUrlArray;
    
    NSMutableArray *_eventNameArray;
    NSMutableArray *_eventAddressArray;
    NSMutableArray *_eventDateArray;
    NSMutableArray *_eventTimeArray;
    NSMutableArray *_eventDecriptionArray;
    NSMutableArray *_eventUrlArray;
    NSMutableArray *_eventFacebookArray;
}
@property(nonatomic,assign) BOOL           loadingFlag;
@property(nonatomic,retain) NSMutableArray *eventArray;
@property(nonatomic,retain) NSMutableArray *imageUrlArray;

@property(nonatomic,retain) NSMutableArray *eventNameArray;
@property(nonatomic,retain) NSMutableArray *eventAddressArray;
@property(nonatomic,retain) NSMutableArray *eventDateArray;
@property(nonatomic,retain) NSMutableArray *eventTimeArray;
@property(nonatomic,retain) NSMutableArray *eventDecriptionArray;
@property(nonatomic,retain) NSMutableArray *eventUrlArray;
@property(nonatomic,retain) NSMutableArray *eventFacebookArray;

+ (DataManager*)getInstance;
-(void)getEventsAndImageData;

@end
