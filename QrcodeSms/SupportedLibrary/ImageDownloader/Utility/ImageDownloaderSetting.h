//
//  ImageDownloaderSetting.h
//  ImageDownloadManager
//
//  Created by Manish Rathi on 22/11/13.
//  Copyright (c) 2013 Manish Rathi. All rights reserved.
//


/**
    CACHE_POLICY_TYPE avaliable Options
 */
extern NSString * const SWSCachePolicyTypeNone;
extern NSString * const SWSCachePolicyTypeDownloadOnce;
extern NSString * const SWSCachePolicyTypeCheckForUpdate;

// ***************************************************************************

/**
  CLEAR_CACHE_TYPE avaliable Options
 */
extern NSString * const SWSClearCacheNone;
extern NSString * const SWSClearCacheFrequency;
extern NSString * const SWSClearCacheSmall;
extern NSString * const SWSClearCacheLarge;
extern NSString * const SWSClearCacheFIFO;


// ***************************************************************************

/**
 CACHE_LIMIT_TYPE avaliable Options
 */
extern NSString * const SWSCacheLimitNone;
extern NSString * const SWSCacheLimitBySize;
extern NSString * const SWSCacheLimitByFilesCount;


// ***************************************************************************

/**
 CACHE_PRIORITY_TYPE avaliable Options
 */
extern NSString * const SWSCachePriorityFifo;
extern NSString * const SWSCachePriorityFrequency;
extern NSString * const SWSCachePriorityLarge;
extern NSString * const SWSCachePrioritySmall;


/**
  KEYS
 */
extern NSString * const SWSCacheImages;
extern NSString * const SWSCacheImagesContentSize;
extern NSString * const SWSImageUrl;
extern NSString * const SWSImageContentSize;
extern NSString * const SWSImageLocalPath;
extern NSString * const SWSImageFetchCount;