//
//  TraductorViewController.h
//  Softcatala
//
//  Created by Marcos Grau on 09/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdViewController.h"

@interface TraductorViewController : UIViewController < UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate>{
	NSString *txtTextViewUndo;
	IBOutlet UITextView *txtTranslatedText;
	NSString *translatedText;
	NSString *responseStatus;
	NSString *language;
	
	IBOutlet UITextView *txtTextView;
	
	IBOutlet UIPickerView *pickerView;
	NSMutableArray *languagesArray;
	IBOutlet UIButton *btnLanguage;
	
	IBOutlet UIToolbar *keyboardToolbar;
	IBOutlet UIToolbar *pickerToolbar;
	IBOutlet UINavigationBar *mainToolbar;
	IBOutlet UIBarButtonItem *btnTranslate;
	
	IBOutlet AdViewController *adViewController;
	
	UIAlertView *spinnerAlert;	
} 

@property (retain, nonatomic) NSString *txtTextViewUndo;
@property (retain, nonatomic) NSString *translatedText;
@property (retain, nonatomic) IBOutlet UITextView *txtTranslatedText;
@property (retain, nonatomic) NSString *responseStatus;
@property (retain, nonatomic) NSString *language;
@property (retain, nonatomic) IBOutlet UITextView *txtTextView;
@property (retain, nonatomic) IBOutlet UIPickerView *pickerView;
@property (retain, nonatomic) NSMutableArray *languagesArray;
@property (retain, nonatomic) IBOutlet UIButton *btnLanguage;
@property (retain, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
@property (retain, nonatomic) IBOutlet UIToolbar *pickerToolbar;
@property (retain, nonatomic) IBOutlet UINavigationBar *mainToolbar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnTranslate;
@property (retain, nonatomic) IBOutlet AdViewController *adViewController;
@property (retain, nonatomic) UIAlertView *spinnerAlert;

-(void) translateText:(NSString *)text;

-(IBAction) btnTranslatePressed:(id)sender;
-(IBAction) btnChangeLanguagePressed:(id)sender;
-(IBAction) btnKeyboardDonePressed:(id)sender;
-(IBAction) btnKeyboardCancelPressed:(id)sender;
-(IBAction) btnPickerDonePressed:(id)sender;
-(IBAction) btnPickerCancelPressed:(id)sender;

@end
