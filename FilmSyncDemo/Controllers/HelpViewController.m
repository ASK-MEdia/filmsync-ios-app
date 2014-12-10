//
//  HelpViewController.m
//  FilmSyncDemo
//
//  Created by Abdusha on 10/24/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpPageViewController.h"


@interface HelpViewController ()
{
    int totalPagesCount;
}

@end

@implementation HelpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    //Google Analytics : Set screen name for identification
    self.screenName = @"Help Screen";
    
    self.pageController = nil;
    
    //load the help screen configuration from the plist /Resources/HelpScreenPageList.plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HelpScreenPageList" ofType:@"plist"];
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    self.pagesArray = [plistDict objectForKey:@"Pages"];
    
    totalPagesCount = (int) [self.pagesArray count];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {   /* Device is iPad */
        //Set top image
        [self.HelpImageView setImage:[UIImage imageNamed:@"Help_SyncScreen@2x.png"]];
    }
    else
    {   /* Device is iPhone or iPod touch.*/
        //Set top image
        [self.HelpImageView setImage:[UIImage imageNamed:@"Help_SyncScreen.png"]];
    }
    
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if (self.pageController == nil)
    {//setup pageview controller
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.pageController.dataSource = self;
        CGRect viewFrame = [[self view] bounds];
        [[self.pageController view] setFrame:CGRectMake(0.0, 0.0,viewFrame.size.width,viewFrame.size.height - 10)];
        //load the first help page
        HelpPageViewController *initialViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        //add pageview controller
        [self addChildViewController:self.pageController];
        [[self view] addSubview:[self.pageController view]];
        [self.pageController didMoveToParentViewController:self];
 
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (HelpPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    //Get the controller from the storyboard.
    HelpPageViewController *childViewController = (HelpPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HelpPage"];
    childViewController.helpImageSize = self.HelpImageView.frame.size;
    
    childViewController.index = index;
    childViewController.pageDict = [self.pagesArray objectAtIndex:index];

    //HelpPage
    return childViewController;
    
}

//Help page swipe to right
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(HelpPageViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
}

//Help page swipe to left
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(HelpPageViewController *)viewController index];
    
    index++;
    
    if (index == totalPagesCount) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return totalPagesCount;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
