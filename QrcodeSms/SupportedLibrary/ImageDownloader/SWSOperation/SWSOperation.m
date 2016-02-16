//
//  SWSOperation.m
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


#import "SWSOperation.h"
#import "ImageDownloaderSetting.h"
#import "NSFileManager+Cache.h"
#import "SWSDownloadManager.h"
@interface SWSOperation (){
    NSString *cachePolicyType;
    NSString *cachePriority;
    NSDictionary *httpResponse;
}
@property (nonatomic)long long dataLengthOfConnection;
@end


@implementation SWSOperation

#pragma mark - Custom Init
#pragma mark -------------------------------------
- (id)initWithRequest:(NSURLRequest *)urlRequest withDelegate:(id)delegate{
    return [self initWithRequest:urlRequest withDelegate:delegate withCacheType:SWSCachePolicyTypeNone];
}
- (id)initWithRequest:(NSURLRequest *)urlRequest withDelegate:(id)delegate withCacheType:(NSString *)cacheType{
    return [self initWithRequest:urlRequest withDelegate:delegate withCacheType:cacheType withPriorityType:SWSCachePrioritySmall];
}
- (id)initWithRequest:(NSURLRequest *)urlRequest withDelegate:(id)delegate withCacheType:(NSString *)cacheType withPriorityType:(NSString *)priorityType{
    self = [super init];
    if (!self) {
		return nil;
    }
    self.request = urlRequest;
    self.delegate= delegate;
    cachePolicyType=cacheType;
    cachePriority=priorityType;
    return self;
}

#pragma mark - NSURLConnectionDataDelegate
#pragma mark -------------------------------------
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *imgResponse = (NSHTTPURLResponse *) response;
    
    httpResponse = [imgResponse allHeaderFields];
    if (imgResponse.statusCode > 401 ||
        ![httpResponse[@"Content-Type"] hasPrefix:@"image/"]
        ) {
        httpResponse = nil;
        //Call Failure Delagate
        if (self.delegate && [self.delegate respondsToSelector:@selector(UrlOperation:didFailWithError:ofURLRequest:)]) {
            [self.delegate UrlOperation:self didFailWithError:nil ofURLRequest:_request];
        }
        return;
    } else if (cachePolicyType == SWSCachePolicyTypeCheckForUpdate) {
        __weak SWSDownloadManager *manager = [SWSDownloadManager instance];
        NSDictionary *imageInHand = [manager loadCachedDataForURL:response.URL];
        if ([imageInHand[@"modified-date"] isEqualToString:httpResponse[@"Last-Modified"]]) {
            httpResponse = nil;
            //Call Delagate with local Image-Data
            if (self.delegate && [self.delegate respondsToSelector:@selector(UrlOperation:withData:ofURLRequest:)]) {
                NSFileManager *fileManager=[NSFileManager defaultManager];
                NSMutableData *imgData=(NSMutableData *)[fileManager contentsAtPath:imageInHand[SWSImageLocalPath]];
                [self.delegate NeedToCancelUrlOperation:self withImageData:imgData];
            }
            return;
        }
    }
    
    _dataLengthOfConnection = [response expectedContentLength];
    if (self.delegate && [self.delegate respondsToSelector:@selector(UrlOperation:didReceiveResponse:ofURLRequest:)]) {
        [self.delegate UrlOperation:self didReceiveResponse:response ofURLRequest:_request];
    }
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data{
    [_responseData appendData:data];
    float progress=((float)[_responseData length] / (float)_dataLengthOfConnection);
    if (self.delegate && [self.delegate respondsToSelector:@selector(UrlOperation:withProgress:ofURLRequest:)]) {
        [self.delegate UrlOperation:self withProgress:progress ofURLRequest:_request];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    if (self.delegate && [self.delegate respondsToSelector:@selector(UrlOperation:withData:ofURLRequest:)]) {
        [self.delegate UrlOperation:self withData:_responseData ofURLRequest:_request];
    }

    NSString *filePath;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *contentType = httpResponse[@"Content-Type"];
    NSString *extention = [contentType stringByReplacingOccurrencesOfString:@"image/" withString:@""];
    filePath =[NSString stringWithFormat:@"%@.%@",[[NSFileManager defaultManager] uniqueImageName],extention];
    NSNumber *imageSize = httpResponse[@"Content-Length"];
    NSString *modifiedDate = httpResponse[@"Last-Modified"];
    NSDictionary *fileData =
    @{SWSImageUrl: [[[connection originalRequest] URL] absoluteString],
      SWSImageLocalPath: filePath,
      SWSImageContentSize: imageSize,
      @"modified-date": modifiedDate,
      SWSImageFetchCount:@0};
    
    //Add the new image to array
    NSMutableArray *arrImages = [[ud objectForKey:SWSCacheImages] mutableCopy];
    if (arrImages == nil) {
        arrImages = [NSMutableArray array];
    }
    [arrImages addObject:fileData];
    
    //Re Calculate Total Image Size
    NSNumber *totalImageSize = [ud objectForKey:SWSCacheImagesContentSize];
    long long intTotalSize = 0;
    if (totalImageSize == nil) {
        intTotalSize = [imageSize longLongValue];
    } else {
        intTotalSize = [totalImageSize longLongValue] + [imageSize longLongValue];
    }
    [ud synchronize];
    __weak SWSDownloadManager *manager = [SWSDownloadManager instance];
    if (manager.cacheLimitType == SWSCacheLimitBySize) {
        while (manager.sizeLimit < intTotalSize) {
            intTotalSize = [self removeAFile: arrImages andInitialSize:intTotalSize];
        }
    } else if (manager.cacheLimitType == SWSCacheLimitByFilesCount) {
        while (manager.filesLimit < [arrImages count]) {
            intTotalSize = [self removeAFile: arrImages andInitialSize:intTotalSize];
        }
    } else {
        while (manager.sizeLimit < intTotalSize && manager.filesLimit < [arrImages count]) {
            intTotalSize = [self removeAFile: arrImages andInitialSize:intTotalSize];
        }
    }
    totalImageSize = @(intTotalSize);
    [ud setObject:arrImages forKey:SWSCacheImages];
    [ud setObject:totalImageSize forKey:SWSCacheImagesContentSize];
    
    [ud synchronize];
    [_responseData writeToFile:filePath atomically:YES];
    _responseData = nil;
    httpResponse = nil;
    _connection = nil;
}

#pragma mark - NSURLConnectionDelegate
#pragma mark -------------------------------------
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    _connection = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(UrlOperation:didFailWithError:ofURLRequest:)]) {
        [self.delegate UrlOperation:self didFailWithError:error ofURLRequest:_request];
    }
}

#pragma mark - Override Start Function  @Manish
#pragma mark -------------------------------------
- (void)start{
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
    _responseData = [[NSMutableData alloc] init];
    [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_connection start];
}

#pragma mark - Override Cancel Function  @Manish
#pragma mark -------------------------------------
- (void)cancel{
    //Cancel NSURLConnection
    [_connection cancel];
     _connection = nil;
    
     //Call Super's Cancel Now
    [super cancel];
}

#pragma mark - Helper Methods
#pragma mark -------------------------------------
- (long long int) removeAFile:(NSMutableArray *) arrImages andInitialSize: (long long int) intTotalSize{
    __block NSUInteger index = NSNotFound;
    __block long long int value = 0;
    
    if(cachePriority==SWSCachePriorityFifo){
        index = 0;
    }else if(cachePriority==SWSCachePriorityFrequency){
        value = HUGE_VAL;
        [arrImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSInteger currentValue =[[obj objectForKey:SWSImageContentSize] integerValue];
            if (currentValue < value ) {
                value = currentValue;
                index = idx;
            }
        }];
    }else if(cachePriority==SWSCachePriorityLarge){
        value = 0;
        [arrImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            long long int currentValue = [[obj objectForKey:SWSImageContentSize] longLongValue];
            if (currentValue > value) {
                value = currentValue;
                index = idx;
            }
        }];
    }else if(cachePriority==SWSCachePrioritySmall){
        value = HUGE_VAL;
        [arrImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            long long int currentValue = [[obj objectForKey:SWSImageContentSize] longLongValue];
            if (currentValue < value) {
                value = currentValue;
                index = idx;
            }
        }];
    }else{
        return intTotalSize;
    }
    
    return [self removeFileAtIndex:index fromArray:arrImages withInitialSize:intTotalSize];
}

- (long long int) removeFileAtIndex: (NSInteger) index fromArray: (NSMutableArray *) arrImages withInitialSize: (long long int) intTotalSize{
    NSDictionary *fileDetails = arrImages[index];
    NSString *fileToDiscard = fileDetails[SWSImageLocalPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fileToDiscard error:nil];
    intTotalSize -= [fileDetails[SWSImageContentSize] longLongValue];
    [arrImages removeObjectAtIndex:index];
    return intTotalSize;
}
@end