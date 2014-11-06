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

@end

@implementation HelpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (HelpPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    NSLog(@"viewControllerAtIndex ");
    
    // 3. Get the controller from the storyboard.
    HelpPageViewController *childViewController = (HelpPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HelpPage"];
    childViewController.index = index;
    
    //HelpPage
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSLog(@"viewControllerBeforeViewController ");
    NSUInteger index = [(HelpPageViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSLog(@"viewControllerAfterViewController ");
    NSUInteger index = [(HelpPageViewController *)viewController index];
    
    index++;
    
    if (index == 4) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    NSLog(@"presentationCountForPageViewController ");
    // The number of items reflected in the page indicator.
    return 4;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    NSLog(@"presentationIndexForPageViewController ");
    // The selected item reflected in the page indicator.
    return 0;
}

@end
