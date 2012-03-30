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

static inline ccRange
ccr(const int start, const int end, const int y)
{
	ccRange c = {start, end, y};
	return c;
}

@interface CCSpriteFloodFill : CCSprite {
	
	CCTexture2DMutable * mutableTexture;
	//	CCArray * PixelQueue;
	BOOL pixelsChecked[1024][768];

	ccColor4B targetColor;
	ccColor4B startingColor;
}

+ (id)spriteWithImage:(UIImage *)image;
- (id)initWithImage:(UIImage *)image;


-(void)linearFillFromX:(NSInteger)startX andY:(NSInteger)startY;
-(void)prepareFill;
-(void)floodFillTexture :(CGPoint) UvTxtCoord;

- (void)fillFromPoint:(CGPoint)pos withColor:(ccColor4B)col;

@end
