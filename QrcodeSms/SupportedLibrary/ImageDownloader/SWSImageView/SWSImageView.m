//
//  SWSImageView.m
//  ImageDownloadManager
//
//  Created by Manish Rathi on 19/11/13.
//  Copyright (c) 2013 Manish Rathi. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "SWSImageView.h"
#import "SWSDownloadManager.h"
#import "SWSOperationProtocol.h"
#import "SWSOperation.h"
#import "NSFileManager+Cache.h"
#import "LLACircularProgressView.h"

/**
 UIActivityIndicatorView Class Interface
 */
@interface SWSImageActivityIndicatorView : UIActivityIndicatorView
- (id)initWithStyle:(ProgressViewStyle)style;
@end

/**
SWSImageView Class Extension
 */
@interface SWSImageView ()<SWSOperationProtocol,SWSDownloadManagerProtocol>

//ProgressView Style
@property (nonatomic)ProgressViewStyle prgViewStyle;

//NSOperation
@property(nonatomic,strong) SWSOperation *operation;

//UIPragressBar
@property(nonatomic,strong) UIProgressView *downloadProgressBar;

//UIActivityIndicator
@property(nonatomic,strong) SWSImageActivityIndicatorView *activityIndicatorView;

//Circular ProgressBar
@property (nonatomic, strong) LLACircularProgressView *circularProgressView;
@end

/**
 SWSImageView Class Implementation
 */
@implementation SWSImageView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //Init
    }
    return self;
}

#pragma mark - load-Image
#pragma mark -------------------------------------
//Load-Image (with No Progress-Indicator & No Cache)
-(void)loadImageWithUrl:(NSURL *)url{
    [self loadImageWithUrl:url withDefaultImage:nil];
}
-(void)loadImageWithUrl:(NSURL *)url withDefaultImage:(UIImage *)defaultImg{
    [self loadImageWithUrl:url withDefaultImage:defaultImg ProgressViewStyle:PROGRESS_NONE];
}

//Load-Image (with No Cache)
-(void)loadImageWithUrl:(NSURL *)url ProgressViewStyle:(ProgressViewStyle)progressStyle{
    [self loadImageWithUrl:url withDefaultImage:nil ProgressViewStyle:progressStyle];
}
-(void)loadImageWithUrl:(NSURL *)url withDefaultImage:(UIImage *)defaultImg ProgressViewStyle:(ProgressViewStyle)progressStyle{
    //Set Default Image
    if (defaultImg!=nil) {
        self.image=defaultImg;
    }else{
        self.image=nil;
    }
    
    //Set Style
    _prgViewStyle =progressStyle;
    
    //Fetch Image Now
    [self fetchImageWithUrl:url];
}


#pragma mark - Download Progress-View Control
#pragma mark -------------------------------------
-(void)showDownloadProgressView{
    switch (_prgViewStyle) {
        case PROGRESS_WHITE_ACTIVITY:
        case PROGRESS_WHITE_LARGE_ACTIVITY:
        case PROGRESS_GRAY_ACTIVITY:{
            if (_activityIndicatorView==nil) {
                _activityIndicatorView=[[SWSImageActivityIndicatorView alloc] initWithStyle:_prgViewStyle];
                [_activityIndicatorView setCenter:self.center];
                [self addSubview:_activityIndicatorView];
                [self bringSubviewToFront:_downloadProgressBar];
            }
            if (![_activityIndicatorView isAnimating]) {
                [_activityIndicatorView startAnimating];
            }
            [_activityIndicatorView setHidden:NO];
            break;
        }
        case PROGRESS_BAR:{
            if (_downloadProgressBar==nil) {
                _downloadProgressBar  = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
                [_downloadProgressBar setCenter:self.center];
                [self addSubview:_downloadProgressBar];
                [self bringSubviewToFront:_downloadProgressBar];
            }
            [_downloadProgressBar setProgress:0.0f animated:NO];
            [_downloadProgressBar setHidden:NO];
            break;
        }
        case PROGRESS_CIRCLE:
            if (_circularProgressView==nil) {
                _circularProgressView = [[LLACircularProgressView alloc] init];
                _circularProgressView.frame = CGRectMake(0, 0, 30, 30);
                _circularProgressView.center = self.center;
                [self addSubview:_circularProgressView];
                [self bringSubviewToFront:_circularProgressView];
            }
            [_circularProgressView setProgress:0.0f animated:NO];
            [_circularProgressView setHidden:NO];
            break;
        case PROGRESS_CUSTOM:
            NSLog(@"PROGRESS_CUSTOM yet to implement");
            break;
        default:
            break;
    }
}

-(void)hideDownloadProgressView{
    switch (_prgViewStyle) {
        case PROGRESS_WHITE_ACTIVITY:
        case PROGRESS_WHITE_LARGE_ACTIVITY:
        case PROGRESS_GRAY_ACTIVITY:{
            if(_activityIndicatorView) {
                [_activityIndicatorView stopAnimating];
                [_activityIndicatorView setHidden:YES];
            }
            break;
        }
        case PROGRESS_BAR:{
            if(_downloadProgressBar) {
                [_downloadProgressBar setHidden:YES];
                [_downloadProgressBar setProgress:0.0f animated:NO];
            }
            break;
        }
        case PROGRESS_CIRCLE:
            if (_circularProgressView) {
                [_circularProgressView setHidden:YES];
                [_circularProgressView setProgress:0.0f animated:NO];
            }
            break;
        case PROGRESS_CUSTOM:
            NSLog(@"PROGRESS_CUSTOM yet to implement");
            break;
        default:
            break;
    }
}

#pragma mark - Fetch-Image
#pragma mark -------------------------------------
-(void)fetchImageWithUrl:(NSURL *)url{
    //Show Progress-Indicator etc.
    [self showDownloadProgressView];
    
    //Remove Operation of this ImageView (If Any)
    if (_operation!=nil) {
        [[SWSDownloadManager instance] removeOperationFromQueue:_operation];
    }
    
    //Download-Image Now
    [[SWSDownloadManager instance] downloadImageWithUrl:url withDelegate:(id)self];
}

#pragma mark - SWSDownloadManagerProtocol
#pragma mark -------------------------------------
-(void)DownloadManager:(SWSDownloadManager *)downloadManager withOperation:(SWSOperation *)imageOperation ofURL:(NSURL*)url{
    [self setOperation:imageOperation];
}

-(void)DownloadManager:(SWSDownloadManager *)downloadManager withData:(NSData *)data ofURL:(NSURL*)url{
    if (data!=nil) {
        __block SWSImageView * __weak weakSelf=self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.image=[UIImage imageWithData:data];
            [weakSelf hideDownloadProgressView];
        });
    }
}

#pragma mark - SWSUrlConnectionDelegate Methods
#pragma mark -------------------------------------
-(void)UrlOperation:(SWSOperation *)operation didReceiveResponse:(NSURLResponse *)response ofURLRequest:(NSURLRequest *)request{
    //@Manish
    //This method will useful for CACHE_POLICY implementation, (CACHE_POLICY_CHECK_FOR_UPDATE)
}

-(void)UrlOperation:(SWSOperation *)operation withProgress:(float)progress ofURLRequest:(NSURLRequest *)request{
    __block UIProgressView * __weak weakDownloadProgressBar=_downloadProgressBar;
    __block UIActivityIndicatorView * __weak weakActivityIndicatorView=_activityIndicatorView;
    __block LLACircularProgressView * __weak weakCircularProgressView=_circularProgressView;
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (_prgViewStyle) {
            case PROGRESS_WHITE_ACTIVITY:
            case PROGRESS_WHITE_LARGE_ACTIVITY:
            case PROGRESS_GRAY_ACTIVITY:{
                if(weakActivityIndicatorView && ![weakActivityIndicatorView isAnimating]) {
                    [weakActivityIndicatorView startAnimating];
                }
                break;
            }
            case PROGRESS_BAR:{
                if(weakDownloadProgressBar) {
                    [weakDownloadProgressBar setProgress:progress animated:YES];
                }
                break;
            }
            case PROGRESS_CIRCLE:
            if(weakCircularProgressView) {
                [weakCircularProgressView setProgress:progress animated:YES];
            }
            break;
            case PROGRESS_CUSTOM:
            NSLog(@"PROGRESS_CUSTOM yet to implement");
            break;
            default:
            break;
        }
    });
}

-(void)UrlOperation:(SWSOperation *)operation withData:(NSMutableData *)data ofURLRequest:(NSURLRequest *)request{
    if (data!=nil) {
        __block SWSImageView * __weak weakSelf=self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.image=[UIImage imageWithData:data];
            [weakSelf hideDownloadProgressView];
        });
    }
    //Cancel Operation Now
    if (_operation!=nil) {
        [[SWSDownloadManager instance] removeOperationFromQueue:_operation];
    }
}

-(void)NeedToCancelUrlOperation:(SWSOperation *)operation withImageData:(NSMutableData *)data{
    if (data!=nil) {
        __block SWSImageView * __weak weakSelf=self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.image=[UIImage imageWithData:data];
            [weakSelf hideDownloadProgressView];
        });
    }
    //Cancel Operation Now
    if (_operation!=nil) {
        [[SWSDownloadManager instance] removeOperationFromQueue:_operation];
    }
}

-(void)UrlOperation:(SWSOperation *)operation didFailWithError:(NSError *)error ofURLRequest:(NSURLRequest *)request{
    //Cancel Operation
    if (_operation!=nil) {
        [[SWSDownloadManager instance] removeOperationFromQueue:_operation];
    }
}

@end

#pragma mark - UIActivityIndicatorView Helper
#pragma mark -------------------------------------
/**
 UIActivityIndicatorView Class Implementation
 */
@implementation SWSImageActivityIndicatorView
- (id) initWithStyle:(ProgressViewStyle) style{
    if (self = [super init]) {
        if (style == PROGRESS_WHITE_ACTIVITY) {
            self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        } else if (style == PROGRESS_WHITE_LARGE_ACTIVITY) {
            self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        } else {
            self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        }
        self.hidesWhenStopped = YES;
    }
    return self;
}
@end