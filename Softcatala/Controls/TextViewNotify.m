//
//  TextViewNotify.m
//  Softcatala
//
//  Created by Marcos Grau on 31/05/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "TextViewNotify.h"

@implementation TextViewNotify

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self.changeTextDelegate textViewNotify:self textChanged:text];
}
@end
