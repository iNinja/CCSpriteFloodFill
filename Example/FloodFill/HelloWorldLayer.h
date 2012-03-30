//
//  HelloWorldLayer.h
//  FloodFill
//
//  Created by Ignacio Inglese on 3/29/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCTexture2DMutable.h"
#import "CCSpriteFloodFill.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	CCSpriteFloodFill * sprite;
	
	ccColor4B Colors[6];
	
	NSUInteger SelectedCrayon;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;



@end
