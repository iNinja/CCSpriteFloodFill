//
//  HelloWorldLayer.m
//  FloodFill
//
//  Created by Ignacio Inglese on 3/29/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://daddytypes.com/archive/house_of_cash_coloring_0.png"]]];
		[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
		sprite = [CCSpriteFloodFill spriteWithImage:image];
		
		[sprite setPosition:ccp(s.width * 0.5, s.height * 0.5)];
		[self addChild:sprite];
		
		Colors[0] = ccc4(255, 0, 0, 255);
		Colors[1] = ccc4(0, 255, 0, 255);
		Colors[2] = ccc4(0, 0, 255, 255);
		Colors[3] = ccc4(120, 120, 30, 255);
		Colors[4] = ccc4(30, 120, 120, 255);
		Colors[5] = ccc4(10, 200, 60, 255);
		
		CCMenuItemImage * color0 = [CCMenuItemImage itemFromNormalImage:@"Btncolor.png" selectedImage:nil target:self selector:@selector(selectedColor:)];
		CCMenuItemImage * color1 = [CCMenuItemImage itemFromNormalImage:@"Btncolor.png" selectedImage:nil target:self selector:@selector(selectedColor:)];
		CCMenuItemImage * color2 = [CCMenuItemImage itemFromNormalImage:@"Btncolor.png" selectedImage:nil target:self selector:@selector(selectedColor:)];
		CCMenuItemImage * color3 = [CCMenuItemImage itemFromNormalImage:@"Btncolor.png" selectedImage:nil target:self selector:@selector(selectedColor:)];
		CCMenuItemImage * color4 = [CCMenuItemImage itemFromNormalImage:@"Btncolor.png" selectedImage:nil target:self selector:@selector(selectedColor:)];
		CCMenuItemImage * color5 = [CCMenuItemImage itemFromNormalImage:@"Btncolor.png" selectedImage:nil target:self selector:@selector(selectedColor:)];
		
		[color0 setTag:0];
		[color1 setTag:1];
		[color2 setTag:2];
		[color3 setTag:3];
		[color4 setTag:4];
		[color5 setTag:5];
		
		[color0 setPosition:ccp(color0.contentSize.width * 1, color0.contentSize.height)];
		[color1 setPosition:ccp(color0.contentSize.width * 2, color0.contentSize.height)];
		[color2 setPosition:ccp(color0.contentSize.width * 3, color0.contentSize.height)];
		[color3 setPosition:ccp(color0.contentSize.width * 4, color0.contentSize.height)];
		[color4 setPosition:ccp(color0.contentSize.width * 5, color0.contentSize.height)];
		[color5 setPosition:ccp(color0.contentSize.width * 6, color0.contentSize.height)];
		
		[color0 setColor:ccc3(255, 0, 0)];
		[color1 setColor:ccc3(0, 255, 0)];
		[color2 setColor:ccc3(0, 0, 255)];
		[color3 setColor:ccc3(120, 120, 30)];
		[color4 setColor:ccc3(30, 120, 120)];
		[color5 setColor:ccc3(10, 200, 60)];
		
		CCMenu * menu = [CCMenu menuWithItems:color0, color1, color2, color3, color4, color5, nil];
		[menu setPosition:CGPointZero];
		[self addChild:menu];
	}
	return self;
}

- (void) selectedColor:(CCMenuItemImage *)image {
	SelectedCrayon = image.tag;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch * touch = [touches anyObject];
	
	CGPoint pos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
	
	[sprite fillFromPoint:pos withColor:Colors[SelectedCrayon]];

}

@end
