//
//  HelpPageViewController.m
//  FilmSyncDemo
//
//  Created by Abdusha on 10/27/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "HelpPageViewController.h"

@interface HelpPageViewController ()

@end

@implementation HelpPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*NSLog(@"#3 helpImageSize w:%f h:%f",self.helpImageSize.width,self.helpImageSize.height);
    NSLog(@"#3 view w:%f h:%f",self.view.frame.size.width,self.view.frame.size.height);
    
    
    CGSize helpViewSize = self.helpContentView.frame.size;
    CGSize viewSize = self.view.frame.size;
    //[self.helpContentView setFrame:CGRectMake(viewSize.width/2 - helpViewSize.width/2, self.helpImageSize.height + 5, helpViewSize.width, helpViewSize.height)];
    [self.helpContentView setFrame:CGRectMake(viewSize.width/2 - helpViewSize.width/2, self.helpImageSize.height + (viewSize.width - 54 - self.helpImageSize.height)/2, helpViewSize.width, helpViewSize.height)];
    //[self.helpContentView setFrame:CGRectMake(0,0,300,100)];
    [self.view addSubview:self.helpContentView];*/
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {   /* Device is iPad */
        //Configure view with Help Image fot index
        [self.helpImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SS_%d.png",self.index]]];
    }
    else
    {   /* Device is iPhone or iPod touch.*/
        //Configure view with Help Image fot index
        [self.helpImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SS_%d.png",self.index]]];
    }
    
    if (self.index == 2)
    {//Help screen Cotact for more
        [self.filmsyncURLButton setHidden:NO];
    }
    else
    {
        [self.filmsyncURLButton setHidden:YES];
    }
}


//load filmSync site in safari App
- (IBAction)loadFilmsyncURLButtonTouched:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.filmsync.org"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
