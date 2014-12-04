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
    
    // load center iocn and description text
    NSString *icon = [self.pageDict objectForKey:@"icon"];
    NSString *desc = [self.pageDict objectForKey:@"description"];
    
    CGSize viewSize = self.view.frame.size;

    //create a view with available content space. (space below the top image)
    UIView *ContentView = [[UIView alloc] init];
    [ContentView setFrame:CGRectMake(0, self.helpImageSize.height + 20, viewSize.width, viewSize.height - self.helpImageSize.height)];
    [ContentView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:ContentView];
    
    
    float CSpace = ContentView.frame.size.height / 4;
    int spaceBetweenEach = CSpace/8;
    int textViewWidth = 0;
    int iconWidth = 0;
    float textViewFontSize = 0;
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {   // Device is iPad //
        //Configure view for fix the screen size
        iconWidth = 90;
        textViewWidth = viewSize.width * 0.80;
        textViewFontSize = 22.0f;
    }
    else
    {   // Device is iPhone or iPod touch.//
        //Configure view for fix the screen size
        
        
        if (viewSize.height < 500)
        {// Small display devices (iPhone 4S)
            iconWidth = 45;
            textViewWidth = viewSize.width * 0.97;
            textViewFontSize = 11.0f;
            spaceBetweenEach = 5;
        }
        else
        {// bigger display devices (> iPhone 4S)
            iconWidth = 60;
            textViewWidth = viewSize.width * 0.9;
            textViewFontSize = 14.0f;
        }
        
        
    }
    // Create Icon
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    CGRect iconRect = CGRectMake(viewSize.width/2 - iconWidth/2, spaceBetweenEach , iconWidth, iconWidth);
    [iconImageView setFrame:iconRect];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    [ContentView addSubview:iconImageView];
    
    // Resize the textView (added on Storyboard) to fit on content view
    CGRect textRect = CGRectMake(viewSize.width/2 - textViewWidth/2, iconWidth +  spaceBetweenEach , textViewWidth , ContentView.frame.size.height - iconRect.size.height - (spaceBetweenEach *2));
    [self.helpTextView setFrame:textRect];
    [self.helpTextView setFont:[UIFont fontWithName:@"Arial" size:textViewFontSize]];
    [self.helpTextView setText:desc];
    [ContentView addSubview:self.helpTextView];
    
    //NSArray[UIFont familyNames];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
