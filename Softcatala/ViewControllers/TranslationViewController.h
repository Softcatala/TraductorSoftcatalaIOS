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

- (IBAction)changeTranslationDirection:(id)sender;

@end
