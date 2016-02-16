//
//  SWSDownloadManager.h
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


#import <Foundation/Foundation.h>
#import "SWSOperation.h"
#import "SWSDownloadManagerProtocol.h"

@interface SWSDownloadManager : NSObject

//Download-Queue
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

//SingleTon Instance
+ (id)instance;

/**
 Set SWSDownloadManager Delegate
 */
@property(nonatomic,weak) id<SWSDownloadManagerProtocol> delegate;

//CACHE_LIMIT_TYPE
@property(nonatomic,strong) NSString *cacheLimitType;
//MAX-SIZE limit of Cache
@property (nonatomic) long long int sizeLimit;
//MAX-FILE limit in Cache
@property (nonatomic) NSUInteger filesLimit;

//DownLoadImage
-(void)downloadImageWithUrl:(NSURL *)url withDelegate:(id<SWSDownloadManagerProtocol>)delegate;

//Cancel-Operation
-(void)removeOperationFromQueue:(SWSOperation *)operation;

//Helper Method
- (NSDictionary *)loadCachedDataForURL:(NSURL*)url;
@end
