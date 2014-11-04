//
//  HelpPageViewController.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/27/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpPageViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *screenNumber;
@property (weak, nonatomic) IBOutlet UIImageView *helpImageView;

@end
