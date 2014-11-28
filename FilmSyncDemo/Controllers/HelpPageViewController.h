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
@property (assign , nonatomic) CGSize helpImageSize;
@property (weak, nonatomic) IBOutlet UIImageView *helpImageView;
@property (weak, nonatomic) IBOutlet UIView *helpContentView;
@property (weak, nonatomic) IBOutlet UIButton *filmsyncURLButton;


- (IBAction)loadFilmsyncURLButtonTouched:(id)sender;

@end
