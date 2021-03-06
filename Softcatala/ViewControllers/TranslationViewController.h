//
//  TranslationViewController.h
//  Softcatala
//
//  Created by marcos on 05/03/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//



@class GarbageTextView;
@class Translation;
@class TextViewNotify;

@interface TranslationViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate >

@property (strong, nonatomic) IBOutlet GarbageTextView *sourceText;
@property (strong, nonatomic) IBOutlet TextViewNotify *destinationText;
@property (strong, nonatomic) IBOutlet UIPickerView *translationsPicker;
@property (strong, nonatomic) IBOutlet UIView *translationPickerView;
@property (strong, nonatomic) IBOutlet UIButton *btnLanguageDirection;
@property (strong, nonatomic) IBOutlet UIButton *btnPickerSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnPickerClose;
@property (strong, nonatomic) IBOutlet UIButton *btnFormesVal;
@property (strong, nonatomic) IBOutlet UIButton *btnSharing;
@property (strong, nonatomic) IBOutlet UILabel *lblFormesValencianes;

- (IBAction)changeTranslationDirection:(id)sender;
- (IBAction)translationDirectionChanged:(id)sender;
- (IBAction)closePicker:(id)sender;
- (IBAction)reverseTranslation:(id)sender;
- (IBAction)checkFormesValencianes:(id)sender;
- (IBAction)sharing:(id)sender;
- (IBAction)popupChangeTranslationDirection:(id)sender;


- (void)loadTranslation:(Translation *)translation;

@end
