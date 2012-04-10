//
//  CCSpriteFloodFill.h
//  FloodFill
//
//  Created by Ignacio Inglese on 3/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCTexture2DMutable.h"

typedef struct _ccRange
{
	int Start;
	int End;
	int Y;
} ccRange;

typedef struct _ccRangeStack
{
	ccRange * base;
	ccRange * top;
	ccRange * stack;
	NSUInteger count;
	
} ccRangeStack;

void initStack(ccRangeStack * stack, NSUInteger count);
void freeStack(ccRangeStack * stack);
BOOL checkStack(ccRangeStack stack);
void resetStack(ccRangeStack * stack);
void pushRange(ccRangeStack * stack, ccRange range);
ccRange popRange(ccRangeStack * stack);


static inline ccRange
ccr(const int start, const int end, const int y)
{
	ccRange c = {start, end, y};
	return c;
}

@interface CCSpriteFloodFill : CCSprite {
	
	CCTexture2DMutable * mutableTexture;
	
	BOOL pixelsChecked[1024][768];

	ccColor4B targetColor;
	ccColor4B startingColor;
	
	ccRangeStack stack;
	
	BOOL animated;
	BOOL animating;
	
}

// Number of steps per animation frame. Only used when ANIMATED is set to YES
@property (nonatomic, assign) NSUInteger stepsPerFrame;

+ (id)spriteWithImage:(UIImage *)image;
+ (id)spriteWithImage:(UIImage *)image animated:(BOOL)anim;
- (id)initWithImage:(UIImage *)image;
- (id)initWithImage:(UIImage *)image animated:(BOOL)anim;

- (void)fillFromPoint:(CGPoint)pos withColor:(ccColor4B)col;


// Internal use
-(void)linearFillFromX:(NSInteger)startX andY:(NSInteger)startY;
-(void)prepareFill;
-(void)floodFillTexture :(CGPoint) UvTxtCoord;

@end
