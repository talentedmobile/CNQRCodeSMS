//
//  NSFileManager+Cache.m
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


#import "NSFileManager+Cache.h"

@implementation NSFileManager (Cache)

-(NSString *)imageCacheFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *cacheFolderPath = [documentsDirectory stringByAppendingPathComponent:@"CacheImage"];
    if (![self fileExistsAtPath:cacheFolderPath]){
        [self createDirectoryAtPath:cacheFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return cacheFolderPath;
}
    
-(NSString *)uniqueImageName{
    return [NSString stringWithFormat:@"%@%04d%d",[self imageCacheFolder], arc4random()%10000,
                                                        (int)([[NSDate date] timeIntervalSince1970])];
}

-(UIImage *)imageFromDiskForPath:(NSString *)imagePath{
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
}

-(NSData *)imageDataFromDiskForPath:(NSString *)imagePath{
    return [NSData dataWithContentsOfFile:imagePath];
}

-(BOOL)deleteImageFromDiskForPath:(NSString *)imagePath{
    return [self removeItemAtPath:imagePath error:nil];
}

-(void)clearAllImagesCache{
    NSString *cacheFolderPath=[self imageCacheFolder];
    for (NSString *file in [self contentsOfDirectoryAtPath:cacheFolderPath error:nil]){
        [self removeItemAtPath:[cacheFolderPath stringByAppendingPathComponent:file] error:nil];
    }
}

-(NSArray *)cacheFolderFilesName{
    return [self contentsOfDirectoryAtPath:[self imageCacheFolder] error:nil];
}

-(NSUInteger)countOfImageCacheFolder{
    return [[self cacheFolderFilesName] count];
}
@end