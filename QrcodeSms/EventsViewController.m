//
//  EventsViewController.m
//  QrcodeSms
//
//  Created by ZongDa on 3/5/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import "DataManager.h"
#import "EventsViewController.h"
#import "EventDetailViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController
@synthesize eventView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [eventView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DataManager getInstance].eventNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *eventName = [[DataManager getInstance].eventNameArray objectAtIndex:indexPath.row];
    NSString *eventDate = [[DataManager getInstance].eventDateArray objectAtIndex:indexPath.row];
    NSString *eventTime = [[DataManager getInstance].eventTimeArray objectAtIndex:indexPath.row];
    
    NSRange  yearRange    = [eventDate rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *eventYear   = [eventDate substringFromIndex:yearRange.location + 1];
    NSRange  monthRange   = [eventDate rangeOfString:@"/"];
    NSString *eventMonth  = [eventDate substringToIndex:monthRange.location];
    NSString *eventDay    = [eventDate substringWithRange:NSMakeRange(monthRange.location + 1,yearRange.location - monthRange.location-1 )];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSDate* myDate = [dateFormatter dateFromString:eventMonth];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
    NSString *month = [formatter stringFromDate:myDate];
    
    NSString *date = [NSString stringWithFormat:@"%@ %@, %@",month,eventDay,eventYear];
    
    [(UILabel *)[cell.contentView viewWithTag:101] setText:eventName];
    [(UILabel *)[cell.contentView viewWithTag:102] setText:date];
    [(UILabel *)[cell.contentView viewWithTag:103] setText:eventTime];
    [(UILabel *)[cell.contentView viewWithTag:104] setText:eventDay];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [(UIImageView*)[cell.contentView viewWithTag:100] setImage:[UIImage imageNamed:@"CellBackgroundS.png"]];
    
    [self performSegueWithIdentifier:@"EventDetailView" sender:nil];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [(UIImageView*)[cell.contentView viewWithTag:100] setImage:[UIImage imageNamed:@"CellBackground.png"]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EventDetailView"]) {
        EventDetailViewController *vc = (EventDetailViewController*)segue.destinationViewController;
        vc.eventname = [[DataManager getInstance].eventNameArray objectAtIndex: index];
        vc.eventAddress = [[DataManager getInstance].eventAddressArray objectAtIndex: index];
        vc.eventDate = [[DataManager getInstance].eventDateArray objectAtIndex: index];
        vc.eventTime = [[DataManager getInstance].eventTimeArray objectAtIndex: index];
        vc.eventDescription = [[DataManager getInstance].eventDecriptionArray objectAtIndex: index];
        vc.eventUrl = [[DataManager getInstance].eventUrlArray objectAtIndex: index];
        vc.eventFacebook = [[DataManager getInstance].eventFacebookArray objectAtIndex:index];
    }
}

@end
