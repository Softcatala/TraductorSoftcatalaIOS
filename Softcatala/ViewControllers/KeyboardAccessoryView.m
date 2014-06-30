//
//  KeyboardAccessoryView.m
//  Softcatala
//
//  Created by Marcos Grau on 30/06/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "KeyboardAccessoryView.h"
#import "LocalizeHelper.h"

@interface KeyboardAccessoryView ()

@property (strong, nonatomic) UIButton *translateButton;
@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation KeyboardAccessoryView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViewWithFrame:frame];
    }
    return self;
}

- (void)configureView
{
}

- (void)configureViewWithFrame:(CGRect )frame
{
    //  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 48)];
//    [self setFrame:CGRectMake(0, 0, self.bounds.size.width, 48)];
    NSLog(@"Frame: %@", NSStringFromCGRect(frame));
    UIView *keyboardAccessoryView = self;
    [keyboardAccessoryView setBackgroundColor:[UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1.0]];
    UIView *whiteBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.frame.size.width, keyboardAccessoryView.frame.size.height)];
    [whiteBackground setBackgroundColor:[UIColor whiteColor]];
    [keyboardAccessoryView addSubview:whiteBackground];
    
    NSString *buttonTitle = LocalizedString(@"ButtonTranslate");
    CGFloat buttonTitleWidth = [buttonTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}].width + 15;
    _translateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_translateButton.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [_translateButton setFrame:CGRectMake(0, 0, buttonTitleWidth, keyboardAccessoryView.frame.size.height)];
    [_translateButton setCenter:CGPointMake(keyboardAccessoryView.frame.size.width - (buttonTitleWidth/2), keyboardAccessoryView.center.y)];
    [_translateButton setTitle:buttonTitle forState:UIControlStateNormal];
    [_translateButton setTitleColor:[UIColor colorWithRed:181.0/255.0 green:0.0 blue:39.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_translateButton addTarget:self action:@selector(touchUpTranslate:) forControlEvents:UIControlEventTouchUpInside];
    [keyboardAccessoryView addSubview:_translateButton];
    
    NSString *closeButtonTitle = LocalizedString(@"ButtonClose");
    CGFloat buttonCloseWidth = [closeButtonTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}].width + 15;
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [_closeButton setFrame:CGRectMake(0, 0, buttonCloseWidth, keyboardAccessoryView.frame.size.height)];
    [_closeButton setCenter:CGPointMake(_closeButton.center.x + 1, keyboardAccessoryView.center.y)];
    [_closeButton setTitle:closeButtonTitle forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor colorWithRed:181.0/255.0 green:0.0 blue:39.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(touchUpClose:) forControlEvents:UIControlEventTouchUpInside];
    [keyboardAccessoryView addSubview:_closeButton];

}

- (void)localizeToChoosenLanguage
{
    [_translateButton setTitle:LocalizedString(@"ButtonTranslate") forState:UIControlStateNormal];
    [_closeButton setTitle:LocalizedString(@"ButtonClose") forState:UIControlStateNormal];
}

- (void)touchUpTranslate:(id)sender
{
    [_delegate keyboardAccessoryView:self touchUpTranslateButton:sender];
}

- (void)touchUpClose:(id)sender
{
    [_delegate keyboardAccessoryView:self touchUpCloseButton:sender];
}
@end
