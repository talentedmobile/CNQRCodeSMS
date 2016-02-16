//
//  QrcodeInfo.m
//  QrcodeSms
//
//  Created by ZongDa on 3/5/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import "QrcodeInfo.h"

@implementation QrcodeInfo

@synthesize type = _type;
@synthesize regNumber = _regNumber;
@synthesize description = _description;
@synthesize time  = _time;
@synthesize other = _other;

- (id)init
{
    self = [super init];  // okay here
    return self;
}

-(id)initWithRegNumber:(int)regNumber Type:(int)type Description:(NSString*)description Time:(NSString*) time Other:(NSString*)other
{
    if ((self = [super init])) {
        self.regNumber = regNumber;
        self.type = type;
        self.description = description;
        self.time = time;
        self.other = other;
    }
    
    return self;
}

@end
