/*********************************************************************
 *  \file GesturesSampleCodeAppDelegate.m
 *  \author Kailoa Kadano
 *  \date 2009/5/28
 *  \class GesturesSampleCodeAppDelegate
 *  \brief Part of GesturesSampleCode
 *  \details
 *
 *  \abstract CLASS_ABSTRACT 
 *  \copyright Copyright 2009 6Tringle LLC. All rights reserved.
 */

#import "GesturesSampleCodeAppDelegate.h"
#import "GesturesSampleCodeViewController.h"

@implementation GesturesSampleCodeAppDelegate

#pragma mark ** Synthesis **
@synthesize window;
@synthesize viewController;

/*********************************************************************/
#pragma mark -
#pragma mark ** Methods **

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

/*********************************************************************/
#pragma mark -
#pragma mark ** AppDelegate Methods **

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

@end
