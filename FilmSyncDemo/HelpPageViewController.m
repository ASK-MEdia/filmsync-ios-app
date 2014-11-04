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
    //self.screenNumber.text = [NSString stringWithFormat:@"Screen #%li", (long)self.index];
    
    [self.helpImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SS_%d.png",self.index]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
