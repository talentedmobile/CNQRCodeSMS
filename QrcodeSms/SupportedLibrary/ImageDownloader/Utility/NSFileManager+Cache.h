//
//  NSFileManager+Cache.h
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

@interface NSFileManager (Cache)

//Cache Folder Path
-(NSString *)imageCacheFolder;

//Get Unique Image Name
-(NSString *)uniqueImageName;
    
//Get Image From Local
-(UIImage *)imageFromDiskForPath:(NSString *)imagePath;
-(NSData *)imageDataFromDiskForPath:(NSString *)imagePath;

//Remove Image
-(BOOL)deleteImageFromDiskForPath:(NSString *)imagePath;

//Clear All-Images Cache
- (void)clearAllImagesCache;

//Return Cache-Folder Files'name Array
-(NSArray *)cacheFolderFilesName;

//Return Count of Cache-Folder
-(NSUInteger)countOfImageCacheFolder;
@end
