//
//  AboutUSViewController.m
//  QrcodeSms
//
//  Created by ZongDa on 3/5/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import "AboutUSViewController.h"

@implementation AboutUSViewController
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
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSURL *htmlFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AboutUs" ofType:@"html"] isDirectory:NO];
    [webView loadRequest:[NSURLRequest requestWithURL:htmlFile]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
