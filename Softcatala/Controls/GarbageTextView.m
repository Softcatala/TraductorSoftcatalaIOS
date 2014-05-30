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
    UILabel *placeholderLabel;
    UIButton *garbageButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customizeControl];
    }
    return self;
}

- (void)customizeControl
{
    self.text = @"";
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, self.superview.frame.size.width, 33)];
    placeholderLabel.font = [UIFont systemFontOfSize:14.0];
    placeholderLabel.textColor = [UIColor colorWithRed:229.0/255.0 green:227.0/255.2 blue:216.0/255.0 alpha:1.0];
    placeholderLabel.text = NSLocalizedString(@"EnterTextToTranslate", nil);
    
    [self.superview addSubview:placeholderLabel];
    self.layer.cornerRadius = 5.0;
    
    if (self.frame.size.width > 30 && self.frame.size.height > 30) {
        self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 25);
        
        garbageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [garbageButton setFrame:CGRectMake(self.frame.size.width - 22, self.frame.size.height - 27, 30, 30)];
        [garbageButton setImage:[UIImage imageNamed:@"paperera"] forState:UIControlStateNormal];
        [garbageButton addTarget:self action:@selector(buttonGarbagePressed) forControlEvents:UIControlEventTouchUpInside];
        [garbageButton setHidden:YES];
        
        [self.superview addSubview:garbageButton];
        [self bringSubviewToFront:garbageButton];        
    }
}

- (void)awakeFromNib{
    [self customizeControl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)buttonGarbagePressed
{
    self.text = @"";
    [placeholderLabel setHidden:NO];
    [garbageButton setHidden:YES];
}

- (void)textChanged:(NSNotification *)notification
{
    if ([self.text length] > 0) {
        [placeholderLabel setHidden:YES];
        [garbageButton setHidden:NO];
    } else if ([self.text length] == 0) {
        [placeholderLabel setHidden:NO];
    }
}

- (void)setText:(NSString *)text
{
    super.text = text;
    if ([text length] > 0) {
        [placeholderLabel setHidden:YES];
        [garbageButton setHidden:NO];
    }
}
@end
