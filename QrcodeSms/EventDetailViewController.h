//
//  EventDetailViewController.h
//  QrcodeSms
//
//  Created by ZongDa on 3/10/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>

@interface EventDetailViewController : UIViewController<UITextViewDelegate,MBProgressHUDDelegate>
{
    int index;
    BOOL showKeyboardFlag;
    NSString *objectID;
    NSMutableArray *attentedUserArray;
    NSMutableArray *attentedUserUrlArray;
}

@property (nonatomic, retain) MBProgressHUD *HUD;

@property(nonatomic, retain) NSString *eventname;
@property(nonatomic, retain) NSString *eventAddress;
@property(nonatomic, retain) NSString *eventDate;
@property(nonatomic, retain) NSString *eventTime;
@property(nonatomic, retain) NSString *eventDescription;
@property(nonatomic, retain) NSString *eventUrl;
@property(nonatomic, retain) NSString *eventFacebook;

@property(nonatomic, retain) IBOutlet UIImageView *imgView;

@property(nonatomic, retain) IBOutlet UIView  *aboutView;
@property(nonatomic, retain) IBOutlet UITextView  *txtView;

@property(nonatomic, retain) IBOutlet UIView  *commentView;
@property(nonatomic, retain) IBOutlet UITextView *commentTxtView;
@property(nonatomic, retain) IBOutlet UITextView *gcommentTxtView;

@property(nonatomic, retain) IBOutlet UIView  *attendView;
@property(nonatomic, retain) IBOutlet UITableView *attendTableView;

- (IBAction)segmentSwitch:(UISegmentedControl *)sender;
- (IBAction)joinView:(id)sender;
- (IBAction)sendComment:(id)sender;
@end
