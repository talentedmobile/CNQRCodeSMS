//
//  JoinViewController.m
//  QrcodeSms
//
//  Created by ZongDa on 3/12/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import "JoinViewController.h"

@implementation JoinViewController
@synthesize url;
@synthesize HUD;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (FBSession.activeSession.isOpen) {
        // Yes, we are open, so lets make a request for user details so we can get the user name.
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        
    } else {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",@"user_events",@"create_event",@"friends_about_me", nil];
        
        [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES
              completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                  // if login fails for any reason, we alert
                  if (error) {
                      // show error to user.
                      UIAlertView *tmp = [[UIAlertView alloc]
                                          initWithTitle:@"error!"
                                          message:@"happen error in facebook login"
                                          delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil, nil];
                      tmp.tag = 100; // to upload
                      [tmp show];
                      
                  } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                      // no error, so we proceed with requesting user details of current facebook session.
                      [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                  } }];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
   
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelFont:[UIFont systemFontOfSize:12]];
        [HUD setLabelText:@"Loading..."];
       
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [HUD hide:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD hide:YES];
}

@end
