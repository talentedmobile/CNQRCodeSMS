//
//  DataManager.m
//  QrcodeSms
//
//  Created by ZongDa on 3/6/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import "DataManager.h"
static DataManager *sharedInstance = nil;



@implementation DataManager

@synthesize loadingFlag = _loadingFlag;
@synthesize eventArray = _eventArray;
@synthesize imageUrlArray = _imageUrlArray;
@synthesize eventNameArray = _eventNameArray;
@synthesize eventAddressArray = _eventAddressArray;
@synthesize eventDateArray = _eventDateArray;
@synthesize eventTimeArray = _eventTimeArray;
@synthesize eventDecriptionArray = _eventDecriptionArray;
@synthesize eventUrlArray = _eventUrlArray;
@synthesize eventFacebookArray = _eventFacebookArray;

+(DataManager*)getInstance{
    if (sharedInstance == nil)
	{
		sharedInstance = [[DataManager alloc] init];
	}
	return sharedInstance;
}
-(id)init
{
    if((self = [super init]))
	{
        self.eventArray           = [[NSMutableArray alloc] init];
        self.imageUrlArray        = [[NSMutableArray alloc] init];
        self.eventNameArray       = [[NSMutableArray alloc] init];
        self.eventAddressArray    = [[NSMutableArray alloc] init];
        self.eventDateArray       = [[NSMutableArray alloc] init];
        self.eventTimeArray       = [[NSMutableArray alloc] init];
        self.eventDecriptionArray = [[NSMutableArray alloc] init];
        self.eventUrlArray        = [[NSMutableArray alloc] init];
        self.eventFacebookArray   = [[NSMutableArray alloc] init];
    }
	return self;
}

-(void)getEventsAndImageData
{
    self.loadingFlag = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //code executed in the background
        NSData* kivaData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:@"http://batta.co/ImageUrls.php"]
                            ];
        NSMutableArray* json = nil;
        if (kivaData) {
            json = [NSJSONSerialization
                    JSONObjectWithData:kivaData
                    options:kNilOptions
                    error:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self parseJsonImageData:json];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //code executed in the background
        NSData* kivaData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:@"http://batta.co/Events.php"]
                            ];
        NSMutableArray* json = nil;
        if (kivaData) {
            json = [NSJSONSerialization
                    JSONObjectWithData:kivaData
                    options:kNilOptions
                    error:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self parseJsonEventsData:json];
        });
    });
}

-(void)parseJsonImageData:(NSMutableArray*)json
{
    [self.imageUrlArray removeAllObjects];
    NSMutableDictionary *dictDate = nil;
    for (int i=0; i< [json count]; i++)
    {
        dictDate = [json objectAtIndex:i];
        [self.imageUrlArray  addObject:[dictDate objectForKey:@"url"]];
    }
}

-(void)parseJsonEventsData:(NSMutableArray*)json
{
    
    NSMutableDictionary *dictDate = nil;
    [self.eventNameArray removeAllObjects];
    [self.eventAddressArray removeAllObjects];
    [self.eventDateArray removeAllObjects];
    [self.eventTimeArray removeAllObjects];
    [self.eventDecriptionArray removeAllObjects];
    [self.eventUrlArray removeAllObjects];
    [self.eventFacebookArray removeAllObjects];
    
    for (int i=0; i< [json count]; i++){
        
        dictDate = [json objectAtIndex:i];
        
        [self.eventNameArray  addObject:[dictDate objectForKey:@"eventname"]];
        [self.eventAddressArray  addObject:[dictDate objectForKey:@"address"]];
        [self.eventDecriptionArray addObject:[dictDate objectForKey:@"description"]];
        [self.eventDateArray addObject:[dictDate objectForKey:@"date"]];
        [self.eventTimeArray addObject:[dictDate objectForKey:@"time"]];
        [self.eventUrlArray addObject:[dictDate objectForKey:@"url"]];
        [self.eventFacebookArray addObject:[dictDate objectForKey:@"facebook"]];
    }
}


@end
