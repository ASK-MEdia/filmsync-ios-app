//
//  TwitterSearchViewController.h
//  FilmSyncDemo
//
//  Created by Abdusha on 9/23/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

extern CGFloat kCollectionFeedWidthPortrait;
extern CGFloat kCollectionFeedWidthLandscape;

@interface TwitterSearchViewController : UIViewController
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tweetTableView;
@property (strong, nonatomic) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end