//
//  HelpViewController.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/24/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface HelpViewController : GAITrackedViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;     //PageController
@property (strong, nonatomic) NSArray *pagesArray;                      //Array of page contents config
@property (weak, nonatomic) IBOutlet UIImageView *HelpImageView;        //Top image

@end
