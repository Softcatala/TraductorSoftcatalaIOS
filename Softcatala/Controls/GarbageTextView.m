//
//  GarbageTextView.m
//  Softcatala
//
//  Created by marcos on 09/03/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "GarbageTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GarbageTextView
{
    BOOL showPlaceHolder;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customizeControl];
    }
    return self;
}

- (void)customizeControl
{
    self.layer.cornerRadius = 5.0;
    showPlaceHolder = YES;
    self.text = NSLocalizedString(@"EnterTextToTranslate", nil);
    
    
    if (self.frame.size.width > 30 && self.frame.size.height > 30) {
        UIButton *garbageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [garbageButton setFrame:CGRectMake(self.frame.size.width - 22, self.frame.size.height - 27, 30, 30)];
        [garbageButton setImage:[UIImage imageNamed:@"paperera"] forState:UIControlStateNormal];
        [garbageButton addTarget:self action:@selector(buttonGarbagePressed) forControlEvents:UIControlEventTouchUpInside];
        [self.superview addSubview:garbageButton];
        [self bringSubviewToFront:garbageButton];
    }
}

- (void)awakeFromNib{
    [self customizeControl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidBeginEditingNotification object:nil];
}

- (void)buttonGarbagePressed
{
    self.text = @"";
}

- (void)textChanged:(NSNotification *)notification
{
    if (showPlaceHolder == YES) {
        self.text = @"";
        showPlaceHolder = NO;
    }
}

@end
