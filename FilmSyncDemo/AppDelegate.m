//
//  AppDelegate.m
//  FilmSyncDemo
//
//  Created by Abdusha on 9/12/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "AppDelegate.h"
#import "CardsViewControllerPOC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [application setIdleTimerDisabled:YES];
    
    /*// Slide Menu
    // Change the background color of navigation bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    // Change the font style of the navigation bar
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 0);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Helvetica-Light" size:21.0], NSFontAttributeName, nil]];
     */
    //self.centerButton = nil;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
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

-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage controller:(UIViewController *)VC
{
    NSLog(@"addCenterButtonWithImage H:%f W:%f",buttonImage.size.height,buttonImage.size.width);
    self.tabBarVC = VC.tabBarController;
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.centerButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    self.centerButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [self.centerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.centerButton setBackgroundImage:highlightImage forState:UIControlStateSelected];
    
    [self.centerButton addTarget:self action:@selector(CenterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat heightDifference = buttonImage.size.height - VC.tabBarController.tabBar.frame.size.height;
    if (heightDifference < 0)
        self.centerButton.center = VC.tabBarController.tabBar.center;
    else
    {
        CGPoint center = VC.tabBarController.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        self.centerButton.center = center;
    }
    
    [VC.tabBarController.view addSubview:self.centerButton];
    self.isCenterButtonAdded = YES;
    
    NSLog(@"tab Items :%@",[self.tabBarVC.tabBar items]);
    NSArray *tabItemsArray = [self.tabBarVC.tabBar items];
    
    UITabBarItem *helpTabItem = [tabItemsArray objectAtIndex:2];
    UIImage *HelpIconImg = [UIImage imageNamed:@"tabIcon_Help.png"];
    HelpIconImg = [HelpIconImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *HelpIconImgSel = [UIImage imageNamed:@"tabIcon_Help_Selected.png"];
    HelpIconImgSel = [HelpIconImgSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Help" image:HelpIconImg selectedImage:HelpIconImg];
    [helpTabItem setImage:HelpIconImg];
    [helpTabItem setSelectedImage:HelpIconImgSel];
    UITabBarItem *listTabItem = [tabItemsArray objectAtIndex:0];
    UIImage *listIconImg = [UIImage imageNamed:@"tabIcon_ProjectList.png"];
    listIconImg = [listIconImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *listIconImgSel = [UIImage imageNamed:@"tabIcon_ProjectList_Selected.png"];
    listIconImgSel = [listIconImgSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Help" image:HelpIconImg selectedImage:HelpIconImg];
    [listTabItem setImage:listIconImg];
    [listTabItem setSelectedImage:listIconImgSel];
    
    //[self.tabBarVC.tabBar setTintColor:[UIColor whiteColor]];
    //[self.tabBarVC.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
    //[self.tabBarVC.tabBar set
    
    //[[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    
}

-(void) CenterButtonPressed :(UIButton *)btn
{
    //[btn setSelected:!btn.isSelected];
    
    [[CardsViewControllerPOC sharedInstance] clearCardView];
    NSLog(@"btn.isSelected : %d",btn.isSelected);
    [self.tabBarVC setSelectedIndex:1];
    
    
}


- (void) rwDataToPlist:(NSString *)fileName playerColor:(NSString *)strPlayer withData:(NSArray *)data

{
    
    // Step1: Get plist file path
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [sysPaths objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSLog(@"Plist File Path: %@", filePath);
    
    // Step2: Define mutable dictionary
    
    NSMutableDictionary *plistDict;
    
    // Step3: Check if file exists at path and read data from the file if exists
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        
    {
        
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
    }
    
    else
        
    {
        
        // Step4: If doesn't exist, start with an empty dictionary
        
        plistDict = [[NSMutableDictionary alloc] init];
        
    }
    
    NSLog(@"plist data: %@", [plistDict description]);
    
    // Step5: Set data in dictionary
    
    [plistDict setValue:data forKey: strPlayer];
    
    // Step6: Write data from the mutable dictionary to the plist file
    
    BOOL didWriteToFile = [plistDict writeToFile:filePath atomically:YES];
    
    if (didWriteToFile)
        
    {
        
        NSLog(@"Write to .plist file is a SUCCESS!");
        
    }
    
    else
        
    {
        
        NSLog(@"Write to .plist file is a FAILURE!");
        
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [application setIdleTimerDisabled:NO];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setIdleTimerDisabled:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setIdleTimerDisabled:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application setIdleTimerDisabled:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [application setIdleTimerDisabled:NO];
}

@end
