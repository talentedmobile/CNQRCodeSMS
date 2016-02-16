//
//  ImageDownloaderSetting.m
//  ImageDownloadManager
//
//  Created by Manish Rathi on 22/11/13.
//  Copyright (c) 2013 Manish Rathi. All rights reserved.
//



/**
 CACHE_POLICY_TYPE avaliable Options
 */
NSString * const SWSCachePolicyTypeNone=@"SWSCachePolicyTypeNone";
NSString * const SWSCachePolicyTypeDownloadOnce=@"SWSCachePolicyTypeDownloadOnce";
NSString * const SWSCachePolicyTypeCheckForUpdate=@"SWSCachePolicyTypeCheckForUpdate";


/**
 CLEAR_CACHE_TYPE avaliable Options
 */
NSString * const SWSClearCacheNone=@"SWSClearCacheNone";
NSString * const SWSClearCacheFrequency=@"SWSClearCacheFrequency";
NSString * const SWSClearCacheSmall=@"SWSClearCacheSmall";
NSString * const SWSClearCacheLarge=@"SWSClearCacheLarge";
NSString * const SWSClearCacheFIFO=@"SWSClearCacheFIFO";


/**
 CACHE_LIMIT_TYPE avaliable Options
 */
NSString * const SWSCacheLimitNone=@"SWSCacheLimitNone";
NSString * const SWSCacheLimitBySize=@"SWSCacheLimitBySize";
NSString * const SWSCacheLimitByFilesCount=@"SWSCacheLimitByFilesCount";


/**
 CACHE_PRIORITY_TYPE avaliable Options
 */
NSString * const SWSCachePriorityFifo=@"SWSCachePriorityFifo";
NSString * const SWSCachePriorityFrequency=@"SWSCachePriorityFrequency";
NSString * const SWSCachePriorityLarge=@"SWSCachePriorityLarge";
NSString * const SWSCachePrioritySmall=@"SWSCachePrioritySmall";





/**
 KEYS
 */
NSString * const SWSCacheImages=@"SWSCacheImages";
NSString * const SWSCacheImagesContentSize=@"SWSCacheImagesContentSize";
NSString * const SWSImageUrl=@"SWSImageUrl";
NSString * const SWSImageContentSize=@"SWSImageContentSize";
NSString * const SWSImageLocalPath=@"SWSImageLocalPath";
NSString * const SWSImageFetchCount=@"SWSImageFetchCount";