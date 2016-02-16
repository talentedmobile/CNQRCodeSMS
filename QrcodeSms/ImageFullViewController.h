//
//  ImageFullViewController.h
//  QrcodeSms
//
//  Created by ZongDa on 3/6/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MBProgressHUD.h"

@interface ImageFullViewController : UIViewController<UIActionSheetDelegate,MBProgressHUDDelegate,MFMailComposeViewControllerDelegate>
{
    BOOL showShareFlag;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIView *shareView;

@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, retain) UIDocumentInteractionController *dic;


-(IBAction)showShareView:(id)sender;
@end
