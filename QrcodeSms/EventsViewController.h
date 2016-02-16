//
//  EventsViewController.h
//  QrcodeSms
//
//  Created by ZongDa on 3/5/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventsViewController : UIViewController< UIAlertViewDelegate, UITableViewDataSource , UITableViewDelegate>
{
    int index;
}
@property(nonatomic,retain) IBOutlet UITableView *eventView;

@end
