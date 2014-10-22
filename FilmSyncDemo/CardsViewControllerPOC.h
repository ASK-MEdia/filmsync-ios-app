//
//  CardsViewControllerPOC.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/13/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmSync.h"

@interface CardsViewControllerPOC : UIViewController<FilmSyncDelegate,UIWebViewDelegate>
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
@property (weak, nonatomic) IBOutlet UITextField *cardIDTextView;

@property BOOL reloadWebView;

- (IBAction)getCardButtonPressed:(id)sender;

-(void)newMarkerReceived:(NSString *)marker;
-(NSDictionary *)getDataForMarker:(NSString *)marker;
-(void)getMarkerDict;

@end
