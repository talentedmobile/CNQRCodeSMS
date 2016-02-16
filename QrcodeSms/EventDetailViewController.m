//
//  EventDetailViewController.m
//  QrcodeSms
//
//  Created by ZongDa on 3/10/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import "EventDetailViewController.h"
#import "JoinViewController.h"
#import "KWTextEditor.h"

@implementation EventDetailViewController

@synthesize eventname;
@synthesize eventAddress;
@synthesize eventDate;
@synthesize eventDescription;
@synthesize eventUrl;
@synthesize eventTime;
@synthesize eventFacebook;
@synthesize imgView;
@synthesize txtView;
@synthesize aboutView;
@synthesize commentView;
@synthesize commentTxtView;
@synthesize gcommentTxtView;
@synthesize attendView;
@synthesize attendTableView;
@synthesize HUD;

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
    
    imgView.image =  [UIImage imageNamed:@"LoadingImage.png"];
    [self downloadImageWithURL:[NSURL URLWithString:eventUrl] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            imgView.image = image;
        }
    }];
    
    
    txtView.text = @"";
    txtView.text = [txtView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",eventname]];
    txtView.text = [txtView.text stringByAppendingString:[NSString stringWithFormat:@"\n\n  %@",eventAddress]];
    txtView.text = [txtView.text stringByAppendingString:[NSString stringWithFormat:@"\n\t\t\t\t %@  %@",eventDate,eventTime]];
    txtView.text = [txtView.text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",eventDescription]];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:txtView.text];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0,[eventname length] + 1)];
    [txtView setAttributedText:string];
    [aboutView setHidden:NO];
    [commentView setHidden:YES];
    [attendView setHidden:YES];
    
    [self registEditorWithTextView:self.commentTxtView];
    self.commentTxtView.text = @"Please set comment:";
    showKeyboardFlag = NO;
    
    NSRange range = [eventFacebook rangeOfString:@"/" options:NSBackwardsSearch];
    objectID = [eventFacebook substringFromIndex:range.location + 1];
    
    attentedUserArray    = [[NSMutableArray alloc] init];
    attentedUserUrlArray = [[NSMutableArray alloc] init];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (void)registEditorWithTextView:(UITextView*)textView
{
    KWTextEditor* textEditor = [[KWTextEditor alloc] initWithTextView:textView];
    
    // callback handlers
    [textEditor setTextDidChangeHandler:^{
        NSLog(@"TextDidChangeHandler: text=%@", textView.text);
    }];
    
    [textEditor setFontDidChangeHandler:^{
        NSLog(@"fontDidChangeHandler: fontName=%@ pointSize=%.1f", textView.font.fontName, textView.font.pointSize);
    }];
    
    __weak KWTextEditor* _textEditor = textEditor;
    [textEditor setEditorDidShowHandler:^{
        NSString *mode = @"";
        if (_textEditor.editorMode == KWTextEditorModeKeyboard) mode = @"keyboard";
        if (_textEditor.editorMode == KWTextEditorModeFontPicker) mode = @"font picker";
        NSLog(@"editorDidShowHandler: %@", mode);
    }];
    
    [textEditor setEditorDidShowHandler:^{
        if (!showKeyboardFlag) {
            showKeyboardFlag = YES;
//            commentView.frame = CGRectOffset(commentView.frame, 0, -150);
        }
    }];
    
    [textEditor setEditorDidHideHandler:^{
        NSLog(@"editorDidHideHandler");
    }];
    
    [textEditor setCloseButtonDidTapHandler:^{
        NSLog(@"closeButtonDidTapHandler");
        showKeyboardFlag = NO;
//        commentView.frame = CGRectOffset(commentView.frame, 0, 150);
    }];
    
    // customize button labels
    textEditor.keyboardButton.title = @"TEXT";
    textEditor.fontButton.title = @"FONT";
    textEditor.closeButton.title = @"DONE";
    
    [textEditor showInView:self.view];
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

- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    switch (selectedSegment){
        case 0:
            [aboutView setHidden:NO];
            [commentView setHidden:YES];
            [attendView setHidden:YES];
            break;
        case 1:
            [aboutView setHidden:YES];
            [commentView setHidden:NO];
            [attendView setHidden:YES];
            [self getEventsComments];
            break;
        case 2:
            [aboutView setHidden:YES];
            [commentView setHidden:YES];
            [attendView setHidden:NO];
            [self getEventsStatus];
            break;
    }
    
}

- (IBAction)joinView:(id)sender
{
    index = -1;
    [self performSegueWithIdentifier:@"JoinView" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"JoinView"]) {
        JoinViewController *vc = (JoinViewController*)segue.destinationViewController;
        if (index == -1) {
            vc.url = eventFacebook;
        }else{
            vc.url = [attentedUserUrlArray objectAtIndex:index];
        }
        
    }
}

- (IBAction)sendComment:(id)sender
{
    if ( showKeyboardFlag == YES) {
        return;
    }
    if (![commentTxtView.text isEqualToString:@"Please set comment:"]&&[commentTxtView.text length] > 0 ) {
        [self controlStatusUsable:YES];
        if (FBSession.activeSession.isOpen) {
            // Yes, we are open, so lets make a request for user details so we can get the user name.
            [self promptUserWithAccountNameForComment];
            
        } else {
            NSArray *permissions = [[NSArray alloc] initWithObjects:
                                    @"publish_stream",@"user_events",@"create_event",@"friends_about_me", nil];
            
            [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          // if login fails for any reason, we alert
                                          if (!error) {
                                              [self promptUserWithAccountNameForComment];
                                          } else {
                                              UIAlertView *tmp = [[UIAlertView alloc]
                                                                  initWithTitle:@"Error"
                                                                  message:@"Some error happened"
                                                                  delegate:self
                                                                  cancelButtonTitle:nil
                                                                  otherButtonTitles:@"Ok", nil];
                                              
                                              [tmp show];
                                              [self controlStatusUsable:NO];
                                          }}];
        }
  
    }else{
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"warning!"
                            message:@"Please input comment"
                            delegate:nil
                            cancelButtonTitle:@"Cancel"
                            otherButtonTitles:nil, nil];
        [tmp show];
    }
}

-(void)controlStatusUsable:(BOOL)usable {
    if (usable) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        [HUD setLabelFont:[UIFont systemFontOfSize:12]];
        [HUD setLabelText:@"Comment Uploading..."];
    } else {
        [HUD hide:YES];
    }
}


-(void)promptUserWithAccountNameForComment {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             UIAlertView *tmp = [[UIAlertView alloc]
                                 initWithTitle:@"Comment to FB?"
                                 message:[NSString stringWithFormat:@"Comment to ""%@"" Account?", user.name]
                                 delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"No",@"Yes", nil];
             tmp.tag = 100; // to upload
             [tmp show];
         }else{
             [self controlStatusUsable:NO];
         }
     }];
}

#pragma  mark alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==100)
    {
        if (buttonIndex==1) {
                        
            NSString *graphPath = [NSString stringWithFormat:@"/%@/comments",objectID];
            // then comment
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    commentTxtView.text, @"message",
                                    nil
                                    ];
            /* make the API call */
            [FBRequestConnection startWithGraphPath:graphPath parameters:params HTTPMethod:@"POST"
                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                       /* handle the result */
                       if (!error) {
                           UIAlertView *tmp = [[UIAlertView alloc]
                                               initWithTitle:@"Success!"
                                               message:@"Success leaving comment!"
                                               delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:nil, nil];
                           [tmp show];
                       }else{
                           UIAlertView *tmp = [[UIAlertView alloc]
                                               initWithTitle:@"Error!"
                                               message:@"Happen some error!"
                                               delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:nil, nil];
                           [tmp show];
                       }
                       [self controlStatusUsable:NO];
                   }];
            
        }else{
            [self controlStatusUsable:NO];
        }
    }
}

-(void)getEventsStatus
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    [HUD setLabelFont:[UIFont systemFontOfSize:12]];
    [HUD setLabelText:@"Getting attend people"];
    
    if (FBSession.activeSession.isOpen) {
        // Yes, we are open, so lets make a request for user details so we can get the user name.
        NSString *graphPath = [NSString stringWithFormat:@"/%@/attending",objectID];
        
        /* make the API call */
        [FBRequestConnection startWithGraphPath:graphPath parameters:nil HTTPMethod:@"GET"
            completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
              /* handle the result */
              if (!error) {
                  
                  [attentedUserArray removeAllObjects];
                  [attentedUserUrlArray removeAllObjects];
                  
                  for (NSDictionary *friendData in [result objectForKey:@"data"])
                  {
                      NSString *name = [friendData objectForKey:@"name"];
                      [attentedUserArray    addObject:name];
                      
                      NSString *userid = [friendData objectForKey:@"id"];
                      [attentedUserUrlArray addObject:[NSString stringWithFormat:@"http://www.facebook.com/%@",userid]];
                  }
                  [attendTableView reloadData];
              }
              [HUD hide:YES];
             }];
        
    } else {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",@"user_events",@"create_event",@"friends_about_me", nil];
        
        [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES
            completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                // if login fails for any reason, we alert
                if (!error) {
                    NSString *graphPath = [NSString stringWithFormat:@"/%@/attending",objectID];
                    
                    /* make the API call */
                    [FBRequestConnection startWithGraphPath:graphPath parameters:nil HTTPMethod:@"GET"
                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                          /* handle the result */
                          if (!error) {
                              
                              for (NSDictionary *friendData in [result objectForKey:@"data"])
                              {
                                  NSString *name = [friendData objectForKey:@"name"];
                                  [attentedUserArray    addObject:name];
                                  
                                  NSString *userid = [friendData objectForKey:@"id"];
                                  [attentedUserUrlArray addObject:[NSString stringWithFormat:@"http://www.facebook.com/%@",userid]];
                                  
                              }
                              [attendTableView reloadData];
                          }
                          [HUD hide:YES];
                         }];
                } else {
                    UIAlertView *tmp = [[UIAlertView alloc]
                                        initWithTitle:@"Error"
                                        message:@"Some error happened"
                                        delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"Ok", nil];
                    
                    [tmp show];
                    [HUD hide:YES];
                }}];
    }
}

-(void)getEventsComments
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    [HUD setLabelFont:[UIFont systemFontOfSize:12]];
    [HUD setLabelText:@"Getting comments of event"];
    
    if (FBSession.activeSession.isOpen) {
        // Yes, we are open, so lets make a request for user details so we can get the user name.
        NSString *graphPath = [NSString stringWithFormat:@"/%@/comments",objectID];
        
        /* make the API call */
        [FBRequestConnection startWithGraphPath:graphPath parameters:nil HTTPMethod:@"GET"
             completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 /* handle the result */
                 if (!error) {
                     gcommentTxtView.text = @"";
                     for (NSDictionary *friendData in [result objectForKey:@"data"])
                     {
                         NSDictionary *from = [friendData objectForKey:@"from"];
                         NSString *name = [from objectForKey:@"name"];
                         gcommentTxtView.text = [gcommentTxtView.text stringByAppendingString:[NSString stringWithFormat:@"%@'s comment:",name]];
                         gcommentTxtView.text = [gcommentTxtView.text stringByAppendingString:@"\n"];
                         NSString *message = [friendData objectForKey:@"message"];
                         gcommentTxtView.text = [gcommentTxtView.text stringByAppendingString:message];
                         gcommentTxtView.text = [gcommentTxtView.text stringByAppendingString:@"\n\n"];
                     }
                 }
                 [HUD hide:YES];
             }];
        
    } else {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",@"user_events",@"create_event",@"friends_about_me", nil];
        [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES
             completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                // if login fails for any reason, we alert
                if (!error) {
                    NSString *graphPath = [NSString stringWithFormat:@"/%@/comments",objectID];
                    
                    /* make the API call */
                    [FBRequestConnection startWithGraphPath:graphPath parameters:nil HTTPMethod:@"GET"
                            completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                         /* handle the result */
                         if (!error) {
                             gcommentTxtView.text = @"";
                             for (NSDictionary *friendData in [result objectForKey:@"data"])
                             {
                                 NSDictionary *from = [friendData objectForKey:@"from"];
                                 NSString *name = [from objectForKey:@"name"];
                                 gcommentTxtView.text = [gcommentTxtView.text stringByAppendingString:[NSString stringWithFormat:@"%@'s comment:",name]];
                                 gcommentTxtView.text = [gcommentTxtView.text stringByAppendingString:@"\n"];
                                 NSString *message = [friendData objectForKey:@"message"];
                                 gcommentTxtView.text = [gcommentTxtView.text stringByAppendingString:message];
                                 gcommentTxtView.text = [gcommentTxtView.text stringByAppendingString:@"\n\n"];
                                 
                             }
                         }
                         [HUD hide:YES];
                            }];
                } else {
                    UIAlertView *tmp = [[UIAlertView alloc]
                                        initWithTitle:@"Error"
                                        message:@"Some error happened"
                                        delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"Ok", nil];
                    
                    [tmp show];
                    [HUD hide:YES];
                }}];
    }
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [attentedUserArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AttendCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [(UILabel *)[cell.contentView viewWithTag:100] setText:[attentedUserArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index = indexPath.row;
    [self performSegueWithIdentifier:@"JoinView" sender:nil];
}
@end
