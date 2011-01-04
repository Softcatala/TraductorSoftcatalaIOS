//
//  UINavigationBackgroundImageBar.m
//  Softcatala
//
//  Created by Marcos Grau on 24/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBackgroundImageBar.h"


@implementation UINavigationBackgroundImageBar


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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
