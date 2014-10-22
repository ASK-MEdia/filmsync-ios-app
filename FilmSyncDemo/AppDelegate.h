//
//  AppDelegate.h
//  FilmSyncDemo
//
//  Created by Abdusha on 9/12/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIButton *centerButton;
@property (strong, nonatomic) UITabBarController *tabBarVC;
@property BOOL isCenterButtonAdded;

-(void) addCenterButtonFromcontroller:(UIViewController *)VC;
@end
