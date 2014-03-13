//
//  TranslationViewController.m
//  Softcatala
//
//  Created by marcos on 05/03/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "TranslationViewController.h"
#import "GarbageTextView.h"

@interface TranslationViewController ()

@end

@implementation TranslationViewController
{
    UIView *keyboardAccessoryView;
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
