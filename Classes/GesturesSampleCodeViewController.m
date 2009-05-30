/*********************************************************************
 *  \file GesturesSampleCodeViewController.m
 *  \author Kailoa Kadano
 *  \date 2009/5/28
 *  \class GesturesSampleCodeViewController
 *  \brief Part of GesturesSampleCode
 *  \details
 *
 *  \abstract CLASS_ABSTRACT 
 *  \copyright Copyright 2009 6Tringle LLC. All rights reserved.
 */

#import "GesturesSampleCodeViewController.h"
#import "GestureView.h"

@implementation GesturesSampleCodeViewController

/*********************************************************************/
#pragma mark -
#pragma mark ** Methods **

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)dealloc
{
    [super dealloc];
}


/*********************************************************************/
#pragma mark -
#pragma mark ** UIViewController Methods **

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
     
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    [(GestureView *) self.view setDelegate:self];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

/*********************************************************************/
#pragma mark -
#pragma mark ** Accesssors **

- (void)regionPath:(NSArray *)regionPath touchesEnded:(BOOL)ended;
{
    NSLog(@"regionPath: %@", regionPath);
    NSLog(@"currently being touched: %@", (ended ? @"no":@"yes"));
}
/*********************************************************************/
#pragma mark -
#pragma mark ** Accesssors **

@end
