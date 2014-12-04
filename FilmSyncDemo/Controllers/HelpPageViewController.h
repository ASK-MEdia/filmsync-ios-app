//
//  HelpPageViewController.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/27/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpPageViewController : UIViewController

@property (assign, nonatomic) NSInteger index;          //index of this page
@property (assign , nonatomic) CGSize helpImageSize;    //size of top image view ( this is used to calculate the aviable space for content)
@property (assign , nonatomic) NSDictionary *pageDict;  //dictionary containing contents for this page
@property (strong, nonatomic) IBOutlet UITextView *helpTextView;    //text view for showing description

@end
