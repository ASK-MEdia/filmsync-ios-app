//
//  TweetCell.h
//  FilmSyncDemo
//
//  Created by Abdusha on 9/23/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel* usernameLabel;

//@property (nonatomic, weak) IBOutlet UILabel* tweetLabel;

@property (nonatomic, weak) IBOutlet UITextView * tweetLabel;

@property (nonatomic, weak) IBOutlet UILabel* dateLabel;

@property (nonatomic, weak) IBOutlet UIImageView* profileImageView;

@property (nonatomic, weak) IBOutlet UIView* profileImageContainer;

@property (nonatomic, weak) IBOutlet UIImageView* bgImageView;

@end
