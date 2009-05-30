/*********************************************************************
 *  \file GestureView.h
 *  \author Kailoa Kadano
 *  \date 2009/5/28
 *  \class GestureView
 *  \brief Part of GesturesSampleCode
 *  \details
 *
 *  \abstract CLASS_ABSTRACT 
 *  \copyright Copyright 2009 6Tringle LLC. All rights reserved.
 */

#import <UIKit/UIKit.h>

#define TOTAL_SUBREGIONS 9 ///< We use nine subregions here.  You can experiment with more or less
#define MAX_X_SUBREGIONS 3
#define MAX_Y_SUBREGIONS 3

@protocol GestureViewDelegate
@optional
- (void)regionPath:(NSArray *)regionPath touchesEnded:(BOOL)ended;
@end


@interface GestureView : UIView 
{
    id delegate;
    NSMutableArray *TouchRecord;   ///< Used to keep track of all current touch track.
    BOOL CurrentlyBeingTouched;
    
    CGRect GestureRegion;
    CGRect SubRegions[TOTAL_SUBREGIONS];
    
    NSMutableArray *RegionPath;
}
@property (retain) id delegate;

//The region paths are sent to the delegate every touches ended, but the delegate can request the current region path while the user is drawing
- (void)requestCurrentRegionPath;

@end
