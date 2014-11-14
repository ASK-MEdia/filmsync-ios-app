//
//  AppDelegate.m
//  FilmSyncDemo
//
//  Created by Abdusha on 9/12/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "AppDelegate.h"
#import "CardsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Disable screen auto timeout
    [application setIdleTimerDisabled:YES];
    //Set white color for status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //Set tab bar icon's text colors
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:142.0f/255.0f green:213.0f/255.0f blue:255.0f/255.0f alpha:1], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    self.isCenterButtonAdded = NO;
    return YES;
}

-(void) addCenterButtonFromcontroller:(UIViewController *)VC
{
    if (!self.isCenterButtonAdded)
    {
        [self addCenterButtonWithImage:[UIImage imageNamed:@"tabIcon_Sync.png"] highlightImage:[UIImage imageNamed:@"tabIcon_Sync_Selected.png"] controller:VC];
        
    }
    
}

//Customise TabBar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage controller:(UIViewController *)VC
{
    self.tabBarVC = VC.tabBarController;
    
    // Customise center button
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.centerButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    self.centerButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [self.centerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.centerButton setBackgroundImage:highlightImage forState:UIControlStateSelected];
    [self.centerButton addTarget:self action:@selector(CenterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //Set button possition
    CGFloat heightDifference = buttonImage.size.height - VC.tabBarController.tabBar.frame.size.height;
    if (heightDifference < 0)
        self.centerButton.center = VC.tabBarController.tabBar.center;
    else
    {
        CGPoint center = VC.tabBarController.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        self.centerButton.center = center;
    }
    
    //Add raised center button to tab bar
    [VC.tabBarController.view addSubview:self.centerButton];
    //Set flag
    self.isCenterButtonAdded = YES;
    
    // Set custom images for tab bar icons
    NSArray *tabItemsArray = [self.tabBarVC.tabBar items];
    
    // Customise left button
    UITabBarItem *listTabItem = [tabItemsArray objectAtIndex:0];
    UIImage *listIconImg = [UIImage imageNamed:@"tabIcon_ProjectList.png"];
    listIconImg = [listIconImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *listIconImgSel = [UIImage imageNamed:@"tabIcon_ProjectList_Selected.png"];
    listIconImgSel = [listIconImgSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [listTabItem setImage:listIconImg];
    [listTabItem setSelectedImage:listIconImgSel];
    
    // Customise right button
    UITabBarItem *helpTabItem = [tabItemsArray objectAtIndex:2];
    UIImage *HelpIconImg = [UIImage imageNamed:@"tabIcon_Help.png"];
    HelpIconImg = [HelpIconImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *HelpIconImgSel = [UIImage imageNamed:@"tabIcon_Help_Selected.png"];
    HelpIconImgSel = [HelpIconImgSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [helpTabItem setImage:HelpIconImg];
    [helpTabItem setSelectedImage:HelpIconImgSel];
    
    
}

//TabBar Sync button pressed
-(void) CenterButtonPressed :(UIButton *)btn
{
    //Setup and load card view
    [[CardsViewController sharedInstance] clearCardView];
    [self.tabBarVC setSelectedIndex:1];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //Enable screen auto timeout
    [application setIdleTimerDisabled:NO];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //Enable screen auto timeout
    [application setIdleTimerDisabled:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //Disable screen auto timeout
    [application setIdleTimerDisabled:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //Disable screen auto timeout
    [application setIdleTimerDisabled:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //Enable screen auto timeout
    [application setIdleTimerDisabled:NO];
}

@end
