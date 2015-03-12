//
//  TranslationViewController.m
//  Softcatala
//
//  Created by marcos on 05/03/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "TranslationViewController.h"
#import "GarbageTextView.h"
#import "Translation.h"
#import "TranslationRequest.h"
#import "TranslationDirectionLoader.h"
#import "LanguageDirection.h"
#import "Language.h"
#import "ProgressHud.h"
#import "HistoricArchiver.h"
#import "TextViewNotify.h"
#import "LocalizeHelper.h"
#import "LanguagesViewController.h"
#import "HistoricTableViewController.h"
#import "KeyboardAccessoryView.h"

@interface TranslationViewController () <GarbageTextViewDelegate, TextViewNotifyDelegate, LanguagesViewControllerDelegate, UIPopoverControllerDelegate, KeyboardAccessoryViewDelegate>

@property (strong, nonatomic) UIPopoverController *popOverLanguages;

@end

@implementation TranslationViewController
{
    KeyboardAccessoryView *keyboardAccessoryView;
    NSArray *translationDirections;
    NSInteger currentLanguageDirection;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localizeToChoosenLanguage) name:kLanguageNotification object:nil];

	// Do any additional setup after loading the view.
    TranslationDirectionLoader *translationDirectionLoacer = [[TranslationDirectionLoader alloc] init];
    translationDirections = [translationDirectionLoacer loadAllCombinations];
    [_translationsPicker setDelegate:self];
    [_translationsPicker setDataSource:self];
    currentLanguageDirection = 0;

    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:181.0/255.0 green:0.0 blue:39.0/255.0 alpha:1.0]];

    [_sourceText setGarbageDelegate:self];
    [_btnSharing setHidden:YES];
    [_destinationText setChangeTextDelegate:self];
    [self localizeToChoosenLanguage];
    
    self.sourceText.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (keyboardAccessoryView == nil)
    {
        [self configureAccessoryView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self localizeToChoosenLanguage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self closePicker:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)keyboardAccessoryView:(UIView *)view touchUpTranslateButton:(UIButton *)button
{
    [_sourceText resignFirstResponder];
    if ([[_sourceText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return;
    }
    _sourceText.editable = NO;
    [self performSelector:@selector(translateDelayed) withObject:nil afterDelay:1.0];
}

- (void)keyboardAccessoryView:(UIView *)view touchUpCloseButton:(UIButton *)button
{
    [self.view endEditing:YES];
}

- (void)translateDelayed
{
    [ProgressHud show];
    TranslationRequest *translationRequest = [[TranslationRequest alloc] init];
    LanguageDirection *laguageDirection = translationDirections[currentLanguageDirection];
    if ([_btnFormesVal isSelected]) {
        laguageDirection = [TranslationDirectionLoader loadValencianLanguageDirection];
    }
    NSString *textDirection = [NSString stringWithFormat:@"%@|%@", laguageDirection.sourceLanguage.code, laguageDirection.destinationLanguage.code];
    NSString *cleanedSourceText = [_sourceText.text stringByReplacingOccurrencesOfString:@"*" withString:@""];
    [translationRequest postRequestWithText:cleanedSourceText andTextDirection:textDirection success:^(NSString *translationText) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _destinationText.text = translationText;
            [ProgressHud dismiss];
            _sourceText.editable = YES;
            
            Translation *translation = [[Translation alloc] initWithSourceText:cleanedSourceText translationText:translationText languageDirection:laguageDirection isFavorite:NO];
            [[[HistoricArchiver alloc] init] addTranslation:translation];
            
            if ([self.childViewControllers count] > 0) {
                UITabBarController *tabBarController = self.childViewControllers[0];
                for (UIViewController *viewController in tabBarController.viewControllers) {
                    if ([viewController isKindOfClass:[HistoricTableViewController class]]) {
                        [(HistoricTableViewController *)viewController refreshData];
                    }
                }
            }
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHud dismiss];
            _sourceText.editable = YES;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        });
    }];
}

- (IBAction)changeTranslationDirection:(id)sender {
    // Move picker to bottom
    
    CGFloat bottom = self.view.bounds.size.height;
    [_translationPickerView setCenter:CGPointMake(_translationPickerView.center.x, bottom + _translationPickerView.frame.size.height / 2)];
    [_translationPickerView setHidden:NO];
    [_translationsPicker selectRow:currentLanguageDirection inComponent:0 animated:NO];
    [_sourceText setUserInteractionEnabled:NO];
    CGFloat destinationHeight = _translationPickerView.center.y - _translationPickerView.frame.size.height;

    [UIView animateWithDuration:.5 animations:^{
        [_translationPickerView setCenter:CGPointMake(_translationPickerView.center.x, destinationHeight)];
        [_btnSharing setAlpha:0.0];
    }];
}

- (IBAction)popupChangeTranslationDirection:(id)sender
{
    LanguagesViewController *languagesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"popoverLanguages"];
    languagesVC.currentLanguageDirection = currentLanguageDirection;
    languagesVC.delegate = self;
    _popOverLanguages = [[UIPopoverController alloc] initWithContentViewController:languagesVC];
    _popOverLanguages.delegate = self;
    [_popOverLanguages presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

- (IBAction)translationDirectionChanged:(id)sender {
    CGFloat bottom = self.view.frame.size.height;
    [_sourceText setUserInteractionEnabled:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [_translationPickerView setCenter:CGPointMake(_translationPickerView.center.x, bottom + _translationPickerView.frame.size.height / 2)];
    } completion:^(BOOL finished) {
        [_translationPickerView setHidden:YES];
        [_btnSharing setAlpha:1.0];
    }];

    if ([_translationsPicker selectedRowInComponent:0] != currentLanguageDirection) {
        currentLanguageDirection = [_translationsPicker selectedRowInComponent:0];
        LanguageDirection *languageDirection = translationDirections[currentLanguageDirection];
        [_btnLanguageDirection setTitle:languageDirection.description forState:UIControlStateNormal];
        [self refreshFormesValencianesState:languageDirection];
    }
}

- (IBAction)closePicker:(id)sender {
    CGFloat bottom = self.view.frame.size.height;
    CGFloat destinationHeight = bottom + _translationPickerView.center.y;
    [UIView animateWithDuration:0.5 animations:^{
        _translationPickerView.center = CGPointMake(_translationPickerView.center.x, destinationHeight);
        [_sourceText setUserInteractionEnabled:YES];
        [_btnSharing setAlpha:1.0];
    } completion:^(BOOL finished) {
        [_translationPickerView setHidden:YES];
    }];
}

- (IBAction)reverseTranslation:(id)sender {
    LanguageDirection *selectedDirecion = [translationDirections objectAtIndex:currentLanguageDirection];

    _sourceText.text = [_destinationText.text stringByReplacingOccurrencesOfString:@"*" withString:@""];
    
    if ([_sourceText.text isEqualToString:@""]) {
        return;
    }
    
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
    [_btnLanguageDirection setTitle:reverseDirection.description forState:UIControlStateNormal];
    [self refreshFormesValencianesState:reverseDirection];
    [self translateDelayed];
}

- (IBAction)checkFormesValencianes:(id)sender {
    _btnFormesVal.selected = !_btnFormesVal.selected;
}

- (IBAction)sharing:(id)sender {
    if ([[_destinationText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return;
    }
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[_destinationText.text] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)refreshFormesValencianesState:(LanguageDirection *)languageDirection {
    if ([languageDirection.destinationLanguage.code isEqualToString:@"ca"] && [languageDirection.sourceLanguage.code isEqualToString:@"es"]) {
        [_btnFormesVal setSelected:NO];
        [_btnFormesVal setEnabled:YES];
        [_lblFormesValencianes setHidden:NO];
        [_btnFormesVal setHidden:NO];
    } else {
        [_btnFormesVal setSelected:NO];
        [_btnFormesVal setEnabled:NO];
        [_lblFormesValencianes setHidden:YES];
        [_btnFormesVal setHidden:YES];
    }

}

- (void)loadTranslation:(Translation *)translation
{
    LanguageDirection *languageDirection = translation.languageDirection;
    [_btnLanguageDirection setTitle:languageDirection.description forState:UIControlStateNormal];
    [self refreshFormesValencianesState:languageDirection];
    if ([languageDirection.destinationLanguage.code isEqualToString:@"ca_valencia"]) {
        [_btnFormesVal setEnabled:YES];
        [_btnFormesVal setSelected:YES];
        [_lblFormesValencianes setHidden:NO];
        [_btnFormesVal setHidden:NO];
        currentLanguageDirection = 0;
    } else {
        for (LanguageDirection *currentDirection in translationDirections) {
            if ([currentDirection.sourceLanguage.code isEqualToString:languageDirection.sourceLanguage.code] &&
                [currentDirection.destinationLanguage.code isEqualToString:languageDirection.destinationLanguage.code]) {
                currentLanguageDirection = [translationDirections indexOfObject:currentDirection];
                break;
            }
        }
    }
    _sourceText.text = translation.source;
    _destinationText.text = translation.translation;
    [_sourceText resignFirstResponder];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self viewWillAppear:NO];
    }
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
    return languageDirection.description;
}

#pragma mark Configure Keyboard Accessory View
- (void)configureAccessoryView
{
    keyboardAccessoryView = [[KeyboardAccessoryView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 48)];
    keyboardAccessoryView.delegate = self;
    [_sourceText setInputAccessoryView:keyboardAccessoryView];    
}

#pragma mark UITextView delegate for sourceText
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL returnEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsReturnEnabled];
    if (returnEnabled == NO) {
        return YES;
    }
    if([text isEqualToString:@"\n"]) {
        [_sourceText resignFirstResponder];
        [self translateDelayed];
        return NO;
    }
    return YES;
}

#pragma mark GarbageTextView delegate

- (void)garbageTextView:(GarbageTextView *)garbageTextView garbageButtonPressed:(UIButton *)button
{
    _destinationText.text = @"";
}

#pragma mark TextViewNotify delegate

- (void)textViewNotify:(TextViewNotify *)textViewNotify textChanged:(NSString *)text
{
    if ([text length] > 0) {
        [_btnSharing setHidden:NO];
    } else {
        [_btnSharing setHidden:YES];
    }
}

#pragma mark Localization choosen Language
- (void)localizeToChoosenLanguage
{
    translationDirections = nil;
    TranslationDirectionLoader *translationDirectionLoacer = [[TranslationDirectionLoader alloc] init];
    translationDirections = [translationDirectionLoacer loadAllCombinations];
    [_translationsPicker reloadAllComponents];

    [keyboardAccessoryView localizeToChoosenLanguage];
    
    LanguageDirection *languageDirection = translationDirections[currentLanguageDirection];
    [_btnLanguageDirection setTitle:languageDirection.description forState:UIControlStateNormal];
    [_btnPickerSelect setTitle:LocalizedString(@"ButtonPickerSelect") forState:UIControlStateNormal];
    [_btnPickerClose setTitle:LocalizedString(@"ButtonPickerClose") forState:UIControlStateNormal];
    
    [_lblFormesValencianes setText:LocalizedString(@"ButtonFormesValencianes")];
    
    [self.tabBarItem setTitle:LocalizedString(@"ButtonBarTranslate")];
    UITabBarItem *historicItem = self.tabBarController.tabBar.items[1];
    [historicItem setTitle:LocalizedString(@"ButtonHistoric")];
    UITabBarItem *favouriteItem = self.tabBarController.tabBar.items[2];
    [favouriteItem setTitle:LocalizedString(@"ButtonFavourites")];
    [_sourceText updateLocalizedTexts];
    
}

#pragma mark LanguagesViewController delegate
- (void)languagesViewController:(LanguagesViewController *)languagesViewController selectedIndex:(NSInteger)selectedIndex
{
    [_popOverLanguages dismissPopoverAnimated:YES];

    if (selectedIndex != currentLanguageDirection) {
        currentLanguageDirection = selectedIndex;
        LanguageDirection *languageDirection = translationDirections[currentLanguageDirection];
        [_btnLanguageDirection setTitle:languageDirection.description forState:UIControlStateNormal];
        [self refreshFormesValencianesState:languageDirection];
    }
    _popOverLanguages = nil;
}

- (void)languagesViewControllerDidClose:(LanguagesViewController *)languagesViewController
{
    [_popOverLanguages dismissPopoverAnimated:YES];
    _popOverLanguages = nil;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    _popOverLanguages = nil;
}

@end
