//
//  GarbageTextView.h
//  Softcatala
//
//  Created by marcos on 09/03/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GarbageTextViewDelegate;

@interface GarbageTextView : UITextView

@property (weak) id<GarbageTextViewDelegate> garbageDelegate;

- (void)textChanged:(NSNotification*)notification;

@end

@protocol GarbageTextViewDelegate <NSObject>

- (void)garbageTextView:(GarbageTextView *)garbageTextView garbageButtonPressed:(UIButton *)button;

@end