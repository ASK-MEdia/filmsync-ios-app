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
    //NSLog(@"#3 helpImageSize w:%f h:%f",self.helpImageSize.width,self.helpImageSize.height);
    //NSLog(@"#3 view w:%f h:%f",self.view.frame.size.width,self.view.frame.size.height);
    
    
    
    NSString *icon = [self.pageDict objectForKey:@"icon"];
    NSString *desc = [self.pageDict objectForKey:@"description"];
    NSLog(@"page icon : %@",icon);
    NSLog(@"page desc : %@",desc);
    
    CGSize helpViewSize = self.helpContentView.frame.size;
    CGSize viewSize = self.view.frame.size;
    //[self.helpContentView setFrame:CGRectMake(viewSize.width/2 - helpViewSize.width/2, self.helpImageSize.height + 5, helpViewSize.width, helpViewSize.height)];
    //[self.helpContentView setFrame:CGRectMake(viewSize.width/2 - helpViewSize.width/2, self.helpImageSize.height + (viewSize.height - self.helpImageSize.height)/2, helpViewSize.width, helpViewSize.height)];
    [self.helpContentView setFrame:CGRectMake(viewSize.width/2 - helpViewSize.width/2, self.helpImageSize.height + 20, helpViewSize.width, helpViewSize.height)];
    //[self.helpContentView setFrame:CGRectMake(0,0,300,100)];
    
    
    UIView *testView = [[UIView alloc] init];
    [testView setFrame:CGRectMake(0, self.helpImageSize.height + 20, viewSize.width, viewSize.height - self.helpImageSize.height)];
    [testView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:testView];
    
    float CSpace = testView.frame.size.height / 4;
    //UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabIcon_ProjectList@3x.png"]];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    CGRect iconRect = CGRectMake(viewSize.width/2 - CSpace/2, CSpace/8, CSpace, CSpace);
    [iconImageView setFrame:iconRect];
    //[iconImageView setCenter:CGPointMake(, CSpace/4 + CSpace)];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    [testView addSubview:iconImageView];
    
    
    int textViewWidth = 320;
    float textViewFontSize = 10.0f;
    if (viewSize.width > 420)
    {
        textViewWidth = viewSize.width * 2/3;
        textViewFontSize = 22.0f;
    }
    
    CGRect textRect = CGRectMake(viewSize.width/2 - textViewWidth/2, CSpace + CSpace/4 , textViewWidth , CSpace * 2);
    UITextView *textView = [[UITextView alloc] initWithFrame:textRect];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setTextColor:[UIColor whiteColor]];
    [textView setTextAlignment:NSTextAlignmentCenter];
    [textView setFont:[UIFont systemFontOfSize:textViewFontSize]];
    [textView setText:desc];
    [textView setSelectable:YES];
    [testView addSubview:textView];
    
    int yStart = self.helpImageSize.height + 20;
    
    
    
    
    [self.helpContentView setBackgroundColor:[UIColor clearColor]];
    //[self.view addSubview:self.helpContentView];
    
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
    {//Help screen Contact for more details
        [self.filmsyncURLButton setHidden:NO];
    }
    else
    {
        [self.filmsyncURLButton setHidden:YES];
    }
    
   NSLog(@"#DidLoad self.helpContentView w:%f h:%f",self.helpContentView.frame.size.width,self.helpContentView.frame.size.height);
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     NSLog(@"#DidApp helpImageSize w:%f h:%f",self.helpImageView.frame.size.width,self.helpImageView.frame.size.height);
    NSLog(@"#DidApp self.helpContentView w:%f h:%f",self.helpContentView.frame.size.width,self.helpContentView.frame.size.height);
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
