//
//  CardsViewControllerPOC.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/13/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmSync.h"
#import "Card.h"

@interface CardsViewControllerPOC : UIViewController<FilmSyncDelegate,UIWebViewDelegate>
{
    NSArray *_markerDataArray;
    Card *_currentCard;
    
}

@property(nonatomic, strong) NSArray *markerDataArray;
@property(nonatomic, strong) Card *currentCard;

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *filmTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *cardDescTextView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (weak, nonatomic) IBOutlet UITextField *cardIDTextView;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UIImageView *syncWaveImageView;
@property (weak, nonatomic) IBOutlet UILabel *syncStatusLabel;

@property BOOL reloadWebView;

#pragma mark Singleton Methods
+ (CardsViewControllerPOC *)sharedInstance;

- (IBAction)getCardButtonPressed:(id)sender;
- (IBAction)tweetButtonPressed:(id)sender;

-(void)newMarkerReceived:(NSString *)marker;
-(NSDictionary *)getDataForMarker:(NSString *)marker;
-(void)getMarkerDict;

-(void)clearCardView;

@end
