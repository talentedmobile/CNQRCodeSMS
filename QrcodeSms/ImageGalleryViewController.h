//
//  ImageGalleryViewController.h
//  QrcodeSms
//
//  Created by ZongDa on 3/5/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ImageGalleryViewController : UIViewController<iCarouselDataSource,iCarouselDelegate,UIActionSheetDelegate>
{
    int prevIndex;
    UIImage *selectedimage;
    NSMutableArray * imageArray;
}

@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (nonatomic,assign) BOOL wrap;
@end
