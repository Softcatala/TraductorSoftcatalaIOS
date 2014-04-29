//
//  TranslationViewController.m
//  Softcatala
//
//  Created by marcos on 05/03/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "TranslationViewController.h"
#import "GarbageTextView.h"
#import "TranslationRequest.h"
#import "TranslationDirectionLoader.h"
#import "LanguageDirection.h"
#import "Language.h"
#import "ProgressHud.h"

@interface TranslationViewController ()

@end

@implementation TranslationViewController
{
    UIView *keyboardAccessoryView;
    NSArray *translationDirections;
    NSInteger currentLanguageDirection;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    TranslationDirectionLoader *translationDirectionLoacer = [[TranslationDirectionLoader alloc] init];
    translationDirections = [translationDirectionLoacer loadAllCombinations];
    [_translationsPicker setDelegate:self];
    [_translationsPicker setDataSource:self];
    currentLanguageDirection = 0;
    
    [_btnPickerSelect setTitle:NSLocalizedString(@"ButtonPickerSelect", nil) forState:UIControlStateNormal];
    [_btnPickerClose setTitle:NSLocalizedString(@"ButtonPickerClose", nil) forState:UIControlStateNormal];

    [self.tabBarItem setTitle:NSLocalizedString(@"ButtonBarTranslate", nil)];
    [self.tabBarItem setImage:[UIImage imageNamed:@"tab_bar_traduir_off"]];
    [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_bar_traduir_on"]];
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:181.0/255.0 green:0.0 blue:39.0/255.0 alpha:1.0]];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (keyboardAccessoryView == nil)
    {
        [self configureAccessoryView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)translate:(id)sender
{
    [_sourceText resignFirstResponder];
    [self performSelector:@selector(translateDelayed) withObject:nil afterDelay:1.0];
}

- (void)closeBar:(id)sender
{
    [self.view endEditing:YES];
}

- (void)translateDelayed
{
    [ProgressHud show];
    TranslationRequest *translationRequest = [[TranslationRequest alloc] init];
    LanguageDirection *laguageDirection = translationDirections[currentLanguageDirection];
    NSString *textDirection = [NSString stringWithFormat:@"%@|%@", laguageDirection.sourceLanguage.code, laguageDirection.destinationLanguage.code];
    NSString *cleanedSourceText = [_sourceText.text stringByReplacingOccurrencesOfString:@"*" withString:@""];
    [translationRequest postRequestWithText:cleanedSourceText andTextDirection:textDirection success:^(NSString *translation) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _destinationText.text = translation;
            [ProgressHud dismiss];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHud dismiss];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        });
    }];
}

- (IBAction)changeTranslationDirection:(id)sender {
    // Move picker to bottom
    CGFloat bottom = self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height;
    [_translationPickerView setCenter:CGPointMake(_translationPickerView.center.x, bottom + _translationPickerView.frame.size.height / 2)];
    [_translationPickerView setHidden:NO];
    [_sourceText setUserInteractionEnabled:NO];
    
    CGFloat destinationHeight = _translationPickerView.center.y - _translationPickerView.frame.size.height;
    [UIView animateWithDuration:.5 animations:^{
        [_translationPickerView setCenter:CGPointMake(_translationPickerView.center.x, destinationHeight)];
    }];
}

- (IBAction)translationDirectionChanged:(id)sender {
    CGFloat bottom = self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height;
    [_sourceText setUserInteractionEnabled:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [_translationPickerView setCenter:CGPointMake(_translationPickerView.center.x, bottom + _translationPickerView.frame.size.height / 2)];
        [_translationPickerView setHidden:YES];
    }];

    if ([_translationsPicker selectedRowInComponent:0] != currentLanguageDirection) {
        currentLanguageDirection = [_translationsPicker selectedRowInComponent:0];
        LanguageDirection *languageDirection = translationDirections[currentLanguageDirection];
        NSString *languageDirectionTxt = [NSString stringWithFormat:@"%@ > %@", languageDirection.sourceLanguage.name, languageDirection.destinationLanguage.name];
        [_btnLanguageDirection setTitle:languageDirectionTxt forState:UIControlStateNormal];
    }
        
}

- (IBAction)closePicker:(id)sender {
    [_translationPickerView setHidden:YES];
    [_sourceText setUserInteractionEnabled:YES];
}

- (IBAction)reverseTranslation:(id)sender {
    LanguageDirection *selectedDirecion = [translationDirections objectAtIndex:currentLanguageDirection];

    _sourceText.text = [_destinationText.text stringByReplacingOccurrencesOfString:@"*" withString:@""];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        LanguageDirection *languageDirection = (LanguageDirection *)evaluatedObject;
        if (languageDirection.sourceLanguage == selectedDirecion.destinationLanguage &&
            languageDirection.destinationLanguage == selectedDirecion.sourceLanguage) {
            return YES;
        }
        return NO;
    }];
    LanguageDirection *reverseDirection = [[translationDirections filteredArrayUsingPredicate:predicate] firstObject];
    NSInteger reverseDirectionIndex = [translationDirections indexOfObject:reverseDirection];
    currentLanguageDirection = reverseDirectionIndex;
    NSString *languageDirectionTxt = [NSString stringWithFormat:@"%@ > %@", reverseDirection.sourceLanguage.name, reverseDirection.destinationLanguage.name];
    [_btnLanguageDirection setTitle:languageDirectionTxt forState:UIControlStateNormal];
    
    
    [self translateDelayed];
}

#pragma mark PickerView methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [translationDirections count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LanguageDirection *languageDirection = translationDirections[row];
    return [NSString stringWithFormat:@"%@ > %@", languageDirection.sourceLanguage.name, languageDirection.destinationLanguage.name];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //currentLanguageDirection = row;
}



#pragma mark Configure Keyboard Accessory View
- (void)configureAccessoryView
{
    keyboardAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 48)];
    [keyboardAccessoryView setBackgroundColor:[UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1.0]];
    UIView *whiteBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, keyboardAccessoryView.frame.size.height - 2)];
    [whiteBackground setBackgroundColor:[UIColor whiteColor]];
    [keyboardAccessoryView addSubview:whiteBackground];
    
    NSString *buttonTitle = NSLocalizedString(@"ButtonTranslate", nil);
    CGFloat buttonTitleWidth = [buttonTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}].width + 15;
    UIButton *translateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [translateButton setFrame:CGRectMake(0, 0, buttonTitleWidth, keyboardAccessoryView.frame.size.height)];
    [translateButton setCenter:CGPointMake(keyboardAccessoryView.frame.size.width - (buttonTitleWidth/2), keyboardAccessoryView.center.y)];
    [translateButton setTitle:buttonTitle forState:UIControlStateNormal];
    [translateButton setTitleColor:[UIColor colorWithRed:181.0/255.0 green:0.0 blue:39.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [translateButton addTarget:self action:@selector(translate:) forControlEvents:UIControlEventTouchUpInside];
    [keyboardAccessoryView addSubview:translateButton];
    
    NSString *closeButtonTitle = NSLocalizedString(@"ButtonClose", nil);
    CGFloat buttonCloseWidth = [closeButtonTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}].width + 15;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 0, buttonCloseWidth, keyboardAccessoryView.frame.size.height)];
    [closeButton setCenter:CGPointMake(closeButton.center.x, keyboardAccessoryView.center.y)];
    [closeButton setTitle:closeButtonTitle forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithRed:181.0/255.0 green:0.0 blue:39.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeBar:) forControlEvents:UIControlEventTouchUpInside];
    [keyboardAccessoryView addSubview:closeButton];
    
    [_sourceText setInputAccessoryView:keyboardAccessoryView];
}

@end
