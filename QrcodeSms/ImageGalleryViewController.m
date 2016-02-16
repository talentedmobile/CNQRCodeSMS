//
//  ImageGalleryViewController.m
//  QrcodeSms
//
//  Created by ZongDa on 3/5/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import "ImageGalleryViewController.h"
#import "ImageFullViewController.h"
#import "ImageFullViewController.h"
#import "DataManager.h"

#define ITEM_SPACING 200

@implementation ImageGalleryViewController
@synthesize carousel;
@synthesize wrap;

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
    imageArray = [[NSMutableArray alloc] init];
    carousel.type = iCarouselTypeCoverFlow2;
    carousel.delegate = self;
    carousel.dataSource = self;
    wrap = YES;
    prevIndex = 0;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [carousel reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [[DataManager getInstance].imageUrlArray count] ;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(70, 80, 180, 260)];    
    if ([imageArray count] <= index) {
        view.image = [UIImage imageNamed:@"LoadingImage.png"];
        NSString *path =[[DataManager getInstance].imageUrlArray objectAtIndex:index];
        [self downloadImageWithURL:[NSURL URLWithString:path] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                view.image = image;
                // cache the image for use later (when scrolling up)
                [imageArray addObject:image];
            }
        }];
    }else{
        view.image = [imageArray objectAtIndex:index];
    }
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return [[DataManager getInstance].imageUrlArray count];
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return wrap;
}

- (void)carousel:(iCarousel *)icarousel didSelectItemAtIndex:(NSInteger)index
{
    if (prevIndex == index) {
        
        selectedimage = [imageArray objectAtIndex:index];
        
        [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"CurrentIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"ShowFullImage" sender:nil];
    }else{
        prevIndex = index;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowFullImage"]) {
        ImageFullViewController *viewController = [segue destinationViewController];
        viewController.image = selectedimage;
    }
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                     queue:[NSOperationQueue mainQueue]
         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
             if ( !error )
             {
                 UIImage *image = [[UIImage alloc] initWithData:data];
                 completionBlock(YES,image);
             } else{
                 completionBlock(NO,nil);
             }
         }];
}

@end
