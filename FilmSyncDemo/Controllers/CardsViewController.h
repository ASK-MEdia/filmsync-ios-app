//
//  CardsViewController.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/13/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmSync.h"
#import "Card.h"

@interface CardsViewController : UIViewController<FilmSyncDelegate,UIWebViewDelegate>
{
    NSString *_currentCardID;
}

@property(nonatomic, strong) NSString *currentCardID;               // Current card ID

@property (weak, nonatomic) IBOutlet UILabel *filmTitleLabel;       //Film Title
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;     //Webview
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;         //TweetButton
@property (weak, nonatomic) IBOutlet UIImageView *syncWaveImageView;//Sync Animation Image
@property (weak, nonatomic) IBOutlet UILabel *syncStatusLabel;      //Sync info text


#pragma mark Singleton Methods
+ (CardsViewController *)sharedInstance;

// Tweet button pressed
- (IBAction)tweetButtonPressed:(id)sender;
// New marker received
-(void)newMarkerReceived:(NSString *)marker;
//  Clear card view
-(void)clearCardView;

@end
