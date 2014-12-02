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
    
    
    self.pageController = nil;
    
    
    NSLog(@"helpImageSize w:%f h:%f",self.HelpImageView.frame.size.width,self.HelpImageView.frame.size.height);
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HelpScreenPageList" ofType:@"plist"];
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    self.pagesArray = [plistDict objectForKey:@"Pages"];
    
    totalPagesCount = [self.pagesArray count];
    
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
        HelpPageViewController *initialViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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
    //CGSize helpViewSize = childViewController.helpContentView.frame.size;
    //CGSize viewSize = self.view.frame.size;
    childViewController.helpImageSize = self.HelpImageView.frame.size;
    //[childViewController.helpContentView setFrame:CGRectMake(viewSize.width/2 - helpViewSize.width/2, helpViewSize.height + 50, helpViewSize.width, viewSize.height - helpImageSize.height - 100)];
    
    childViewController.index = index;
    childViewController.pageDict = [self.pagesArray objectAtIndex:index];
    
    
    //NSLog(@"#2 helpImageSize w:%f h:%f",self.HelpImageView.frame.size.width,self.HelpImageView.frame.size.height);
    //NSLog(@"#2 view w:%f h:%f",self.view.frame.size.width,self.view.frame.size.height);
    //NSLog(@"#2 view bounds w:%f h:%f",self.view.bounds.size.width,self.view.bounds.size.height);
    
    //HelpPage
    return childViewController;
    
}

//Swipe to right
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(HelpPageViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
}

//Swipe to left
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
