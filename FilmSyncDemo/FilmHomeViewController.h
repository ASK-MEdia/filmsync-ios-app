//
//  FilmHomeViewController.h
//  FilmSyncDemo
//
//  Created by Abdusha on 9/24/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "FilmSync.h"

@interface FilmHomeViewController : UIViewController <FilmSyncDelegate>
{
    NSArray *_markerDataArray;
}

@property(nonatomic, strong) NSArray *markerDataArray;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *filmTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *cardDescTextView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (weak, nonatomic) IBOutlet UITextField *testMarkerTextField;
-(IBAction)testMarkerButtonPressed:(id)sender;

-(void)newMarkerReceived:(NSString *)marker;
-(NSDictionary *)getDataForMarker:(NSString *)marker;
-(void)getMarkerDict;

@end
