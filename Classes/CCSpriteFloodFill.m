//
//  CCSpriteFloodFill.m
//  FloodFill
//
//  Created by Ignacio Inglese on 3/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSpriteFloodFill.h"

BOOL checkPixel(ccColor4B pixel, ccColor4B color);
BOOL checkStack(void);
void pushRange(ccRange range);
ccRange popRange(void);

ccRange *tos, *p1, stack[786432];

BOOL checkPixel(ccColor4B pixel, ccColor4B color)
{
	return pixel.r == color.r && pixel.g == color.g && pixel.b == color.b;
}

BOOL checkStack(void)
{
	return p1 == tos;
}

void resetStack(void)
{
	tos = p1 = stack;
}

void pushRange(ccRange range)
{
	p1++;
	
	assert(p1 != (tos + 786432) );

	*p1 = range;
}

ccRange popRange(void)
{
	assert(p1 != tos);

	p1--;
	return *(p1+1);
}

@implementation CCSpriteFloodFill

+ (id)spriteWithImage:(UIImage *)image
{
	return [[[CCSpriteFloodFill alloc] initWithImage:image] autorelease];
}

- (id)initWithImage:(UIImage *)image
{
	CCTexture2DMutable * texture = [[[CCTexture2DMutable alloc] initWithImage:image] autorelease];
	if (self = [super initWithTexture:texture]) {
		mutableTexture = texture;
		
		tos = stack;
		p1 = stack;
	}
	return self;
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
	pushRange(range);
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
	
	resetStack();
	
	int mw = [self contentSize].width;
	int mh = [self contentSize].height;
	
	memset(pixelsChecked, 0, sizeof(BOOL) * mw * mh);
	
}

- (void)fillFromPoint:(CGPoint)pos withColor:(ccColor4B)col {
	
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
		
		if( checkStack() )
		{
			targetColor = col;
			if( targetColor.r <= 15 && targetColor.g <= 15 && targetColor.b <= 15 )
			{
				targetColor = ccc4(20,15,15,255);
			}
			
			[self floodFillTexture: ccp(pixelX, pixelY)];
		}
	}
	
	while( ! checkStack() )
	{
		ccRange range = popRange();
		
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


@end
