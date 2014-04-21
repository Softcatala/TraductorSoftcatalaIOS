//
//  TranslationViewController.h
//  Softcatala
//
//  Created by marcos on 05/03/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//



@class GarbageTextView;

@interface TranslationViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet GarbageTextView *sourceText;
@property (strong, nonatomic) IBOutlet UITextView *destinationText;
@property (strong, nonatomic) IBOutlet UIPickerView *translationsPicker;
@property (strong, nonatomic) IBOutlet UIView *translationPickerView;
@property (strong, nonatomic) IBOutlet UIButton *btnLanguageDirection;
@property (strong, nonatomic) IBOutlet UIButton *btnPickerSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnPickerClose;

- (IBAction)changeTranslationDirection:(id)sender;
- (IBAction)translationDirectionChanged:(id)sender;
- (IBAction)closePicker:(id)sender;

@end
