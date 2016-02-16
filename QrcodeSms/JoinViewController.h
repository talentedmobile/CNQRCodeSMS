//
//  JoinViewController.h
//  QrcodeSms
//
//  Created by ZongDa on 3/12/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface JoinViewController : UIViewController< UIWebViewDelegate >

@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) MBProgressHUD *HUD;
@end
