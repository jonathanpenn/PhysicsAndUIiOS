//
//  RCWAppDelegate.m
//  Pig Spinner
//
//  Created by Jonathan on 1/1/14.
//  Copyright (c) 2014 Rubber City Wizards. All rights reserved.
//

#import "RCWAppDelegate.h"
#import "RCWSpinnerViewController.h"

@implementation RCWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    RCWSpinnerViewController *controller = [[RCWSpinnerViewController alloc] init];
    self.window.rootViewController = controller;

    [self.window makeKeyAndVisible];
    return YES;
}

@end
