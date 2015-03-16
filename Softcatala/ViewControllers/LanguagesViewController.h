//
//  LanguagesViewController.h
//  Softcatala
//
//  Created by Marcos Grau on 20/06/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LanguagesViewControllerDelegate;

@interface LanguagesViewController : UIViewController

@property (assign, nonatomic) NSInteger currentLanguageDirection;
@property (nonatomic, weak) id<LanguagesViewControllerDelegate> delegate;

@end

@protocol LanguagesViewControllerDelegate <NSObject>

- (void)languagesViewControllerDidClose:(LanguagesViewController *)languagesViewController;
- (void)languagesViewController:(LanguagesViewController *)languagesViewController selectedIndex:(NSInteger)selectedIndex;

@end