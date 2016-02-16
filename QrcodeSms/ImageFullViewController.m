//
//  ImageFullViewController.m
//  QrcodeSms
//
//  Created by ZongDa on 3/6/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import "DataManager.h"
#import "ImageFullViewController.h"
#import "Reachability.h"

@implementation ImageFullViewController

@synthesize imageView;
@synthesize image;
@synthesize shareView;
@synthesize HUD;
@synthesize dic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    showShareFlag = NO;
    [imageView setImage:image];
    
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

-(IBAction)showShareView:(id)sender
{

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", @"Email", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self controlStatusUsable:YES];
            if (FBSession.activeSession.isOpen) {
                // Yes, we are open, so lets make a request for user details so we can get the user name.
                [self promptUserWithAccountNameForUploadPhoto];
                
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
                                                message:@"happen error in facebook uploading"
                                                delegate:nil
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:nil, nil];
                            [tmp show];
                            [self controlStatusUsable:NO];
                            
                        } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                            // no error, so we proceed with requesting user details of current facebook session.
                            [self promptUserWithAccountNameForUploadPhoto];
                        } }];
            }
            break;
        case 1:
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController
                                                       composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                [tweetSheet addImage:image];
                [self presentViewController:tweetSheet animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                    message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
                
            }
            break;
        case 2:
            if ( [MFMailComposeViewController canSendMail] )
            {
                MFMailComposeViewController * mailComposer = [[MFMailComposeViewController alloc] init];
                mailComposer.mailComposeDelegate = self;
                
                
                NSData *imageData = UIImagePNGRepresentation(self.image);
                [mailComposer addAttachmentData:imageData mimeType:@"image/png"
                                       fileName:[NSString stringWithFormat:@"happy.png"]];           
                
                
                
                /* Configure other settings */
                [self presentViewController:mailComposer animated:YES completion:nil];
                
                //[self presentModalViewController:mailComposer animated:YES];
                
            }
            break;
    }
}

-(void)controlStatusUsable:(BOOL)usable {
    if (usable) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        [HUD setLabelFont:[UIFont systemFontOfSize:12]];
        [HUD setLabelText:@"Photo Uploading..."];
    } else {
        [HUD hide:YES];
    }
}

#pragma  mark alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==100)
    {
        if (buttonIndex==1) {
            // then upload
            [FBRequestConnection startForUploadPhoto:image
                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                       [self controlStatusUsable:NO];
                       if (!error) {
                           UIAlertView *tmp = [[UIAlertView alloc]
                                               initWithTitle:@"Success"
                                               message:@"Photo Uploaded"
                                               delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"Ok", nil];
                           
                           [tmp show];
                       } else {
                           UIAlertView *tmp = [[UIAlertView alloc]
                                               initWithTitle:@"Error"
                                               message:@"Some error happened"
                                               delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"Ok", nil];
                           
                           [tmp show];
                       }
                       [self controlStatusUsable:NO];
                   }];
            
        
        }else{
            [self controlStatusUsable:NO];
        }
    }
}

-(void)promptUserWithAccountNameForUploadPhoto {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             UIAlertView *tmp = [[UIAlertView alloc]
                                 initWithTitle:@"Upload to FB?"
                                 message:[NSString stringWithFormat:@"Upload to ""%@"" Account?", user.name]
                                 delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"No",@"Yes", nil];
             tmp.tag = 100; // to upload
             [tmp show];
         }
     }];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
