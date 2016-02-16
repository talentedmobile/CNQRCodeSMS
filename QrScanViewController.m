//
//  QrScanViewController.m
//  QrcodeSms
//
//  Created by ZongDa on 3/5/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import "QrScanViewController.h"
#import "DataManager.h"

@interface QrScanViewController ()

@end

@implementation QrScanViewController
@synthesize readerView, resultView,focusView;

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
    readerView.readerDelegate = self;
    readerView.showsFPS = YES;
    readerView.trackingColor = [UIColor clearColor];
   
    // you can use this to support the simulator
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc]  initWithViewController: self];
        cameraSim.readerView = readerView;
    }
    
    NSURL *musicfile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"]];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicfile error:&error];
    audioPlayer.delegate = self;
    audioPlayer.numberOfLoops = 3;
    if (audioPlayer == nil) {
        NSLog(@"%@",[error description]);
    }
    
    audioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:musicfile error:&error];
    audioPlayer1.delegate = self;
    audioPlayer1.numberOfLoops = 1;
    if (audioPlayer1 == nil) {
        NSLog(@"%@",[error description]);
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [readerView willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void) viewDidAppear: (BOOL) animated
{
    // run the reader when the view is visible
    [readerView start];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [readerView stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark flush on/off

-(IBAction)flashOn:(id)sender
{
    readerView.torchMode = YES;
}

-(IBAction)flashOff:(id)sender
{
    readerView.torchMode = NO;
}

#pragma mark zbar delegate
#pragma mark zBar delegate(get barcode)

- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    
    resultString = @"";
    // do something useful with results
    for(ZBarSymbol *sym in syms) {
        resultString = sym.data;
        break;
    }
    
    if ([syms count] != 0 ) {
        if ([[resultString uppercaseString] rangeOfString:@"SMSTO:"].location != NSNotFound)
        {
            [resultView setText:resultString];
            [audioPlayer setVolume:1.0f];
            [audioPlayer play];
        }else{
            [focusView setImage:[UIImage imageNamed:@"scanner_reticle_green.png"]];
            [audioPlayer1 setVolume:1.0f];
            [audioPlayer1 play];
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    if (player == audioPlayer) {
        [focusView setImage:[UIImage imageNamed:@"scanner_reticle_white.png"]];
        [resultView setText:@""];
        
        NSString *substring = [resultString substringWithRange:NSMakeRange(6,[resultString length]- 6)];
        NSString *recipents = [substring substringWithRange:NSMakeRange(0,[substring  rangeOfString:@":"].location)];
        NSString *text = [substring substringWithRange:NSMakeRange([substring  rangeOfString:@":"].location + 1,([substring length] - 1 -[substring  rangeOfString:@":"].location))];
        if ( [MFMessageComposeViewController canSendText] )
        {
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            controller.messageComposeDelegate = self;
            controller.recipients = [NSArray arrayWithObject:recipents];
            controller.body = text;
            
            /* Configure other settings */
            [self presentViewController:controller animated:YES completion:nil];
        }
    }else if(player == audioPlayer1){
        [focusView setImage:[UIImage imageNamed:@"scanner_reticle_white.png"]];
    }
    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
