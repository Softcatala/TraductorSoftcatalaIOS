//
//  TextViewNotify.h
//  Softcatala
//
//  Created by Marcos Grau on 31/05/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextViewNotifyDelegate;

@interface TextViewNotify : UITextView

@property (weak) id<TextViewNotifyDelegate> changeTextDelegate;

@end

@protocol TextViewNotifyDelegate <NSObject>

- (void)textViewNotify:(TextViewNotify *)textViewNotify textChanged:(NSString *)text;

@end