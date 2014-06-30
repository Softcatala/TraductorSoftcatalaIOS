//
//  LanguagesViewController.m
//  Softcatala
//
//  Created by Marcos Grau on 20/06/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "LanguagesViewController.h"
#import "TRanslationDirectionLoader.h"
#import "LanguageDirection.h"
#import "LocalizeHelper.h"

@interface LanguagesViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *translationDirections;
@property (nonatomic, strong) IBOutlet UIPickerView *translationsPicker;
@property (strong, nonatomic) IBOutlet UIButton *btnPickerSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnPickerClose;

- (IBAction)translationDirectionChanged:(id)sender;
- (IBAction)closePicker:(id)sender;

@end

@implementation LanguagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localizeToChoosenLanguage) name:kLanguageNotification object:nil];

//    TranslationDirectionLoader *translationDirectionLoacer = [[TranslationDirectionLoader alloc] init];
//    _translationDirections = [translationDirectionLoacer loadAllCombinations];
    [_translationsPicker setDelegate:self];
    [_translationsPicker setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self localizeToChoosenLanguage];
    [_translationsPicker selectRow:_currentLanguageDirection inComponent:0 animated:NO];
}

- (IBAction)translationDirectionChanged:(id)sender {
    [self.delegate languagesViewController:self selectedIndex:[_translationsPicker selectedRowInComponent:0]];
}

- (IBAction)closePicker:(id)sender {
    [self.delegate languagesViewControllerDidClose:self];
}

#pragma mark Localization choosen Language
- (void)localizeToChoosenLanguage
{
    _translationDirections = nil;
    TranslationDirectionLoader *translationDirectionLoacer = [[TranslationDirectionLoader alloc] init];
    _translationDirections = [translationDirectionLoacer loadAllCombinations];
    [_translationsPicker reloadAllComponents];
    [_btnPickerSelect setTitle:LocalizedString(@"ButtonPickerSelect") forState:UIControlStateNormal];
    [_btnPickerClose setTitle:LocalizedString(@"ButtonPickerClose") forState:UIControlStateNormal];    
}

#pragma mark PickerView methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_translationDirections count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LanguageDirection *languageDirection = _translationDirections[row];
    return languageDirection.description;
}

@end
