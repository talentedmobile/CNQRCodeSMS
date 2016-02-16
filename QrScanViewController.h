//
//  QrScanViewController.h
//  QrcodeSms
//
//  Created by ZongDa on 3/5/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <EventKit/EventKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface QrScanViewController : UIViewController<ZBarReaderViewDelegate,AVAudioPlayerDelegate,MFMessageComposeViewControllerDelegate>
{
    ZBarReaderView *readerView;
    ZBarCameraSimulator *cameraSim;
    
    UIImage  *resultImage;
    NSString *resultString;
    
    AVAudioPlayer *audioPlayer;
    AVAudioPlayer *audioPlayer1;
}

@property (strong, retain) IBOutlet ZBarReaderView *readerView;
@property (strong, retain) IBOutlet UIImageView *focusView;
@property (strong, retain) IBOutlet UILabel *resultView;

-(IBAction)flashOn:(id)sender;
-(IBAction)flashOff:(id)sender;
@end
