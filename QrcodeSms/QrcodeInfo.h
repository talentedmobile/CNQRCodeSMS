//
//  QrcodeInfo.h
//  QrcodeSms
//
//  Created by ZongDa on 3/5/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QrcodeInfo : NSObject
{
    int       _regNumber;
    int       _type;
    NSString *_description;
    NSString *_time;
    NSString *_other;
}

@property(nonatomic,assign) int regNumber;
@property(nonatomic,assign) int type;
@property(nonatomic,retain) NSString *description;
@property(nonatomic,retain) NSString *time;
@property(nonatomic,retain) NSString *other;

-(id)initWithRegNumber:(int)regNumber Type:(int)type Description:(NSString*)description Time:(NSString*) time Other:(NSString*)other;

@end
