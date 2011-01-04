//
//  UIToolBarBackgroundImage.m
//  Softcatala
//
//  Created by Marcos Grau on 27/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIToolBarBackgroundImage.h"



@implementation UIToolBarBackgroundImage


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
	UIImage *image = [UIImage imageNamed: @"fonsvermell.jpg"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


- (void)dealloc {
    [super dealloc];
}


@end
