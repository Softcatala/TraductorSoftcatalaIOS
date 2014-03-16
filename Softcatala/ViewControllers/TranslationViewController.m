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
#import <SVProgressHUD/SVProgressHUD.h>

@interface TranslationViewController ()

@end

@implementation TranslationViewController
{
    UIView *keyboardAccessoryView;
    NSArray *translationDirections;
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

- (void)translateDelayed
{
    [SVProgressHUD show];
    TranslationRequest *translationRequest = [[TranslationRequest alloc] init];
    [translationRequest postRequestWithText:_sourceText.text andTextDirection:@"es|ca" success:^(NSString *translation) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _destinationText.text = translation;
            [SVProgressHUD dismiss];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        });
    }];
}

- (IBAction)changeTranslationDirection:(id)sender {
    // Move picker to bottom
    CGFloat bottom = self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height;
    [_translationPickerView setCenter:CGPointMake(_translationPickerView.center.x, bottom + _translationPickerView.frame.size.height / 2)];
    [_translationPickerView setHidden:NO];
    CGFloat destinationHeight = _translationPickerView.center.y - _translationPickerView.frame.size.height;
    [UIView animateWithDuration:1.0 animations:^{
        [_translationPickerView setCenter:CGPointMake(_translationPickerView.center.x, destinationHeight)];
    }];
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
    NSLog(@"Selected: %d", row);
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
    [_sourceText setInputAccessoryView:keyboardAccessoryView];
}

@end
