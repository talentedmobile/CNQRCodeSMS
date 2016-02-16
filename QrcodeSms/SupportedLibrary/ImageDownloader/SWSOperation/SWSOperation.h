//
//  SWSOperation.h
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
#import "SWSOperationProtocol.h"

@interface SWSOperation : NSOperation<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

/**
 The request used by the operation's connection.
 */
@property (nonatomic, strong) NSURLRequest *request;

/**
 The data received during the request.
 */
@property (nonatomic, strong) NSMutableData *responseData;

/**
 Set UrlConnection 
 */
@property (nonatomic, strong) NSURLConnection *connection;

/**
 Set SWSOperation Delegate
 */
@property(nonatomic,weak) id<SWSOperationProtocol> delegate;

/**
@param urlRequest The request object to be used by the operation connection.
*/
- (id)initWithRequest:(NSURLRequest *)urlRequest withDelegate:(id)delegate;
- (id)initWithRequest:(NSURLRequest *)urlRequest withDelegate:(id)delegate withCacheType:(NSString *)cacheType;
- (id)initWithRequest:(NSURLRequest *)urlRequest withDelegate:(id)delegate withCacheType:(NSString *)cacheType withPriorityType:(NSString *)priorityType;
@end