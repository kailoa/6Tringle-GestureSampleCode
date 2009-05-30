/*********************************************************************
 *  \file GestureView.m
 *  \author Kailoa Kadano
 *  \date 2009/5/28
 *  \class GestureView
 *  \brief Part of GesturesSampleCode
 *  \details
 *
 *  \abstract CLASS_ABSTRACT 
 *  \copyright Copyright 2009 6Tringle LLC. All rights reserved.
 */

#import "GestureView.h"

#define NSNumberFloat(x) [NSNumber numberWithFloat:x]
#define NSNumberInteger(x) [NSNumber numberWithInteger:x]

@interface GestureView (private_interface)
- (void)sendRegionPathToDelegate;
@end

@implementation GestureView
#pragma mark ** Synthesis **
@synthesize delegate;
#pragma mark ** Static Variables **


//10% or so
#define XPADDING 0.10
#define YPADDING 0.10

/*********************************************************************/
#pragma mark -
#pragma mark ** Methods **

- (void)dealloc {
    [super dealloc];
}

/*********************************************************************/
#pragma mark -
#pragma mark ** UIView Methods **

- (void)drawRect:(CGRect)rect
{
    
    if (CGRectIsEmpty(GestureRegion))
        return;
    CGContextRef context = UIGraphicsGetCurrentContext();

    NSUInteger idx = 0;
    for (int y = 0; y < MAX_X_SUBREGIONS; y++) {
        for (int x = 0; x < MAX_X_SUBREGIONS; x++) {
            CGContextStrokeRect(context, SubRegions[idx]);
            
            if ([RegionPath containsObject:NSNumberInteger(idx)]) {
                
                //these fill values are only for the purpose of "roughly" showing the order the regions are hit.
                //they don't quite work right if you keep touching the same subregion
                CGFloat fill_value = (CGFloat)[RegionPath indexOfObject:NSNumberInteger(idx)]/(CGFloat)([RegionPath count] +3);
                CGContextSetRGBFillColor(context, 1-fill_value, 1-fill_value, 1-fill_value, 1);
                CGContextFillRect(context, SubRegions[idx]);
            }
            
            
            NSString *index_string = [NSString stringWithFormat:@"%d", idx];
            CGContextSetRGBFillColor(context, 0,0,0,1);
            [index_string drawInRect:SubRegions[idx] 
                            withFont:[UIFont fontWithName:@"Marker Felt" size:GestureRegion.size.height/3]
                       lineBreakMode:UILineBreakModeClip
                           alignment:UITextAlignmentCenter];
            
            idx++;
        }
    }
}
/*********************************************************************/
#pragma mark -
#pragma mark ** Gesture Methods **

- (NSUInteger)subregionIndexContainingPoint:(CGPoint)point;
{
    for (int i = 0; i < TOTAL_SUBREGIONS; i++) {
        if (CGRectContainsPoint(SubRegions[i], point))
            return i;
    }
    return TOTAL_SUBREGIONS;
}
- (void)addIndexToRegionPath:(NSUInteger)idx;
{
    //use a naive algorithm for now
    if (idx >= 0 
     && idx < TOTAL_SUBREGIONS) {
        [RegionPath addObject:NSNumberInteger(idx)];
    } else {
        NSLog(@"ERROR: Invalid index!!");
        NSLog(@"idx:%d",idx);
    }
}
- (void)recalculateRegionPath;
{
    if (!RegionPath)
        RegionPath = [[NSMutableArray alloc] init];
    
    [RegionPath removeAllObjects];
        
    for (NSValue *point_value in TouchRecord) {
        CGPoint current_point = [point_value CGPointValue];
        NSUInteger idx = [self subregionIndexContainingPoint:current_point];
        if ([RegionPath count] == 0) {
            [self addIndexToRegionPath:idx];
        } else {
            NSUInteger previous_idx = [[RegionPath lastObject] unsignedIntegerValue];
            if (idx != previous_idx) {
                //NSLog(@"adding index: %d for point:%f,%f", idx, current_point.x, current_point.y);
                [self addIndexToRegionPath:idx];
            }
        }
    }
}
- (void)recalculateSubRegions;
{
    NSUInteger idx = 0;
    
    CGRect gesture_region_padded;
    gesture_region_padded = CGRectInset(GestureRegion, 
                                        GestureRegion.size.width * -1 * XPADDING, 
                                        GestureRegion.size.height * -1 * YPADDING);
    
    CGFloat width = gesture_region_padded.size.width/3;
    CGFloat height = gesture_region_padded.size.height/3;
    
    for (int y = 0; y < MAX_X_SUBREGIONS; y++) {
        for (int x = 0; x < MAX_X_SUBREGIONS; x++) {
            SubRegions[idx] = CGRectMake(0, 0, width, height);
            SubRegions[idx].origin.x = gesture_region_padded.origin.x + (x*width);
            SubRegions[idx].origin.y = gesture_region_padded.origin.y + (y*height);
            
            idx++;
        }
    }
}

- (void)expandGestureRegionIfNecesaryWithTouch:(UITouch *)touch;
{
    CGPoint touch_point = [touch locationInView:self];
    
    if (!CGRectContainsPoint(GestureRegion, touch_point))
    {
        CGRect pixel_rect;
        pixel_rect.origin = touch_point;
        pixel_rect.size = CGSizeMake(1,1);
        
        GestureRegion = CGRectUnion(GestureRegion, pixel_rect);
        [self recalculateSubRegions];
    }
}

/*********************************************************************/
#pragma mark -
#pragma mark ** Touch Handlers **

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    CurrentlyBeingTouched = YES;
    UITouch *touch = [touches anyObject];
    CGPoint touch_point = [touch locationInView:self];
    
    if (!TouchRecord)
        TouchRecord = [[NSMutableArray alloc] init];

    [TouchRecord addObject:[NSValue valueWithCGPoint:touch_point]];
    GestureRegion.origin = touch_point;
    GestureRegion.size = CGSizeZero;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [touches anyObject];
    [self expandGestureRegionIfNecesaryWithTouch:touch];
    CGPoint touch_point = [touch locationInView:self];
    
    [TouchRecord addObject:[NSValue valueWithCGPoint:touch_point]];
    [self recalculateRegionPath];
    [self setNeedsDisplay];
}

- (void)touchesCleanup:(NSSet *)touches;
{
    CurrentlyBeingTouched = NO;
    UITouch *touch = [touches anyObject];
    [self expandGestureRegionIfNecesaryWithTouch:touch];
    [TouchRecord removeAllObjects];
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self sendRegionPathToDelegate];
    [self touchesCleanup:touches];

}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self touchesCleanup:touches];
}

/*********************************************************************/
#pragma mark -
#pragma mark ** Delegate Methods **
- (void)sendRegionPathToDelegate;
{
    if ([delegate respondsToSelector:@selector(regionPath:touchesEnded:)]) {
        
        [delegate regionPath:RegionPath touchesEnded:!CurrentlyBeingTouched];
        
    }
}

/*********************************************************************/
#pragma mark -
#pragma mark ** Accessors **

- (void)requestCurrentRegionPath;
{
    [self sendRegionPathToDelegate];
}

@end