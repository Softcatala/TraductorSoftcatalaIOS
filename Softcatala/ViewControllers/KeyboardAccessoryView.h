//
//  KeyboardAccessoryView.h
//  Softcatala
//
//  Created by Marcos Grau on 30/06/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardAccessoryViewDelegate;

@interface KeyboardAccessoryView : UIView

@property (nonatomic, weak) id<KeyboardAccessoryViewDelegate> delegate;

- (void)localizeToChoosenLanguage;

@end

@protocol KeyboardAccessoryViewDelegate <NSObject>

- (void)keyboardAccessoryView:(UIView *)view touchUpTranslateButton:(UIButton *)button;
- (void)keyboardAccessoryView:(UIView *)view touchUpCloseButton:(UIButton *)button;

@end