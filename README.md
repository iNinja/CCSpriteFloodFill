# CCSpriteFloodFill

CCSpriteFloodFill is a cocos2d-based implementation for flood fill.

It is based upon the code posted here: http://www.cocos2d-iphone.org/forum/topic/25446 by Jeston Furqueron, which in time relies on CCTexture2DMutable, by @manucorporat.
I have applied some optimizations on that code and synthesized it into an easy to add class.

It's fairly simple to use, you need to create your sprite instance using 

    // Create the CCSpriteFloodFill from a UIImage instance

    UIImage * image = someImageOfYours;

    CCSpriteFloodFill * sprite = [CCSpriteFloodFill spriteWithImage:image];
    [sprite setPosition:ccp(someX, someY)];
    [self addChild sprite];

    // Fill it by specifying a position and a color
    
    [sprite fillFromPoint:ccp(someX, someY) withColor:ccc4(r, g, b, a)];

I have tested this class on an iPad 2 using this image: placehold.it/1024x768 and it took 0.79 secs to fill it. It works pretty decent on smaller areas.

Feel free to fork and optimize further this code.
If you find this class helpful, I'd love to hear about it. Drop me a line @ignacioinglese.