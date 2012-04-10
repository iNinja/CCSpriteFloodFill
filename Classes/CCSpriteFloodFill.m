//
//  CCSpriteFloodFill.m
//  FloodFill
//
//  Created by Ignacio Inglese on 3/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSpriteFloodFill.h"

BOOL checkPixel(ccColor4B pixel, ccColor4B color)
{
	return pixel.r == color.r && pixel.g == color.g && pixel.b == color.b;
}

void initStack(ccRangeStack * stack, NSUInteger count)
{
	stack->stack = malloc(sizeof(ccRange *) * count);
	memset(stack->stack, 0, sizeof(ccRange *) * count);
	stack->base = stack->top = stack->stack;
}

void freeStack(ccRangeStack * stack)
{
	free(stack->stack);
	stack->base = stack->top = stack->stack = NULL;
}

BOOL checkStack(ccRangeStack stack)
{
	return stack.top == stack.base;
}

void resetStack(ccRangeStack * stack)
{
	stack->base = stack->top = stack->stack;
}

void pushRange(ccRangeStack * stack, ccRange range)
{
	stack->top++;
	
	assert(stack->top != (stack->base + stack->count) );

	*(stack->top) = range;
}

ccRange popRange(ccRangeStack * stack)
{
	assert(stack->top != stack->base);

	stack->top--;
	return *(stack->top+1);
}

@implementation CCSpriteFloodFill

@synthesize stepsPerFrame;

+ (id)spriteWithImage:(UIImage *)image
{
	return [CCSpriteFloodFill spriteWithImage:image animated:NO];
}

+ (id)spriteWithImage:(UIImage *)image animated:(BOOL)anim
{
	return [[[CCSpriteFloodFill alloc] initWithImage:image animated:anim] autorelease];
}

- (id)initWithImage:(UIImage *)image
{
	return [self initWithImage:image animated:NO];
}

- (id)initWithImage:(UIImage *)image animated:(BOOL)anim
{
	CCTexture2DMutable * texture = [[[CCTexture2DMutable alloc] initWithImage:image] autorelease];
	if (self = [super initWithTexture:texture]) {
		
		animated = anim;
		
		mutableTexture = texture;
		
		initStack(&stack, image.size.width * image.size.height);
		
		self.stepsPerFrame = 30;
	}
	return self;
}

- (void)dealloc
{
	freeStack(&stack);
	
	[super dealloc];
}

- (void)onEnter
{
	[super onEnter];
	
	if (animated) {
		[self scheduleUpdate];
	}
}

- (void)onExit
{
	[super onExit];
	
	if (animated) {
		[self unscheduleUpdate];
	}
}

- (void)update:(ccTime)dt
{
	if( checkStack(stack) )
	{
		animating = NO;
		return;
	}
	
	NSUInteger count = 0;
	
	while (!checkStack(stack) && count < self.stepsPerFrame) {
		ccRange range = popRange(&stack);
		
		int upY = range.Y - 1;
		int downY = range.Y +1;
		for( int i = range.Start; i<= range.End; ++i )
		{
			
			if( range.Y > 0 && !pixelsChecked[i][upY])
			{
				ccColor4B pixel = [mutableTexture pixelAt:ccp(i,upY)];
				if( checkPixel(pixel, startingColor) )
				{
					[self linearFillFromX:i andY:upY];
				}
			}
			
			if( range.Y < [self contentSize].height-1  && !pixelsChecked[i][downY])
			{
				ccColor4B pixel = [mutableTexture pixelAt:ccp(i,downY)];
				if( checkPixel(pixel, startingColor) )
				{
					[self linearFillFromX:i andY: downY];
					
				}
			}
		}	
		
		++count;
	}
	
	if (count > 0) {
		[mutableTexture apply];
		self.dirty = YES;		
	}

}


- (void) linearFillFromX:(NSInteger)startX andY:(NSInteger)startY
{
	//**********************************************************************
	// Scan left
	//**********************************************************************
    
	int lFillLoc = startX;
	
	while (true)
    {
		[mutableTexture setPixelAt:ccp(lFillLoc,startY) rgba:targetColor];

        pixelsChecked[lFillLoc][startY] = YES;
		lFillLoc--;
		
		if( lFillLoc < 0 )
		{
			break;
		}
		
		if( pixelsChecked[lFillLoc][startY] )
		{
			break;
		}
		
		ccColor4B pixel = [mutableTexture pixelAt:ccp(lFillLoc,startY)];
		if( !checkPixel(pixel, startingColor) )
		{
			break;
		}
	}
	lFillLoc++;
	
	//**********************************************************************
	// Scan right
	//**********************************************************************
    int rFillLoc = startX;
	while (true)
    {
		[mutableTexture setPixelAt:ccp(rFillLoc,startY) rgba:targetColor];
        pixelsChecked[rFillLoc][startY] = YES;
		rFillLoc++;
		
		if( rFillLoc >= [self contentSize].width )
		{
			break;
		}
		
		if( pixelsChecked[rFillLoc][startY]  )
		{
			break;
		}
		
		ccColor4B pixel = [mutableTexture pixelAt:ccp(rFillLoc,startY)];
		if( !checkPixel(pixel, startingColor) )
		{
			break;
		}
	}
	rFillLoc--;
	
    //add range to stack
	ccRange range = ccr( lFillLoc, rFillLoc, startY);
	pushRange(&stack, range);
}

-(void)floodFillTexture :(CGPoint) UvTxtCoord
{
	int x = UvTxtCoord.x;
	int y = UvTxtCoord.y;
	
	startingColor = [mutableTexture pixelAt:ccp(x,y)];
	if (startingColor.r == 0 && startingColor.g == 0 && startingColor.b == 0 )
	{
		return;
	}
	
	[self prepareFill];
	[self linearFillFromX:x andY:y];
}

//******************************************************
// Prepare linear queue algorithm
//******************************************************
-(void)prepareFill
{
	
	resetStack(&stack);
	
	int mw = [self contentSize].width;
	int mh = [self contentSize].height;
	
	memset(pixelsChecked, 0, sizeof(BOOL) * mw * mh);
	
}

- (void)fillFromPoint:(CGPoint)pos withColor:(ccColor4B)col {
	
	if (animating) {
		return;
	}
	
	CGPoint WolrdLoc = [self convertToNodeSpace:pos];
	
	int pixelX = 0;
	int pixelY = 0;
	
	int width = [self contentSize].width * self.scaleX;
	int height = [self contentSize].height * self.scaleY;
	
	int rightX = self.position.x + width/2;
	int leftX = self.position.x - width/2;
	int topY = self.position.y + height/2;
	int bottomY = self.position.y - height/2;
	
	if ( (WolrdLoc.x < leftX || WolrdLoc.x > rightX) || (WolrdLoc.y < bottomY || WolrdLoc.y > topY ) )
	{
		
	}
	else
	{
		if( WolrdLoc.x > leftX  && WolrdLoc.x <= rightX)
		{
			int nx = WolrdLoc.x - leftX;
			pixelX = (int)((float)nx/(float)self.scaleX);
		}
		
		if( WolrdLoc.y > bottomY  && WolrdLoc.y <= topY)
		{
			int ny = topY - WolrdLoc.y;
			pixelY = (int)((float)ny/(float)self.scaleY);
		}
		
		if( checkStack(stack) )
		{
			targetColor = col;
			if( targetColor.r <= 15 && targetColor.g <= 15 && targetColor.b <= 15 )
			{
				targetColor = ccc4(20,15,15,255);
			}
			
			[self floodFillTexture: ccp(pixelX, pixelY)];
		}
	}
	
	if (animated) {
		animating = YES;
	}
	else {
		while( ! checkStack(stack) )
		{
			ccRange range = popRange(&stack);
			
			int upY = range.Y - 1;
			int downY = range.Y +1;
			for( int i = range.Start; i<= range.End; ++i )
			{
				
				if( range.Y > 0 && !pixelsChecked[i][upY])
				{
					ccColor4B pixel = [mutableTexture pixelAt:ccp(i,upY)];
					if( checkPixel(pixel, startingColor) )
					{
						[self linearFillFromX:i andY:upY];
					}
				}
				
				if( range.Y < [self contentSize].height-1  && !pixelsChecked[i][downY])
				{
					ccColor4B pixel = [mutableTexture pixelAt:ccp(i,downY)];
					if( checkPixel(pixel, startingColor) )
					{
						[self linearFillFromX:i andY: downY];
						
					}
				}
			}
		}
		
		[mutableTexture apply];
		self.dirty = YES;
		
	}
		
}


@end
