/*********************************************************************
 *  \file GesturesSampleCodeAppDelegate.h
 *  \author Kailoa Kadano
 *  \date 2009/5/28
 *  \class GesturesSampleCodeAppDelegate
 *  \brief Part of GesturesSampleCode
 *  \details
 *
 *  \abstract CLASS_ABSTRACT 
 *  \copyright Copyright 2009 6Tringle LLC. All rights reserved.
 */

#import <UIKit/UIKit.h>

@class GesturesSampleCodeViewController;

@interface GesturesSampleCodeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GesturesSampleCodeViewController *viewController;
}

#pragma mark ** Properties **
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GesturesSampleCodeViewController *viewController;

@end

