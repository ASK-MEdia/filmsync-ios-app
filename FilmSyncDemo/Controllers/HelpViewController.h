//
//  HelpViewController.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/24/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pagesArray;
@property (weak, nonatomic) IBOutlet UIImageView *HelpImageView;

@end
