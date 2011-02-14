//
//  TraductorViewController.m
//  Softcatala
//
//  Created by Marcos Grau on 09/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TraductorViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

@implementation TraductorViewController

@synthesize txtTextViewUndo;
@synthesize txtTranslatedText;
@synthesize translatedText;
@synthesize responseStatus;
@synthesize txtTextView;
@synthesize pickerView;
@synthesize languagesArray;
@synthesize language;
@synthesize btnLanguage;
@synthesize keyboardToolbar;
@synthesize mainToolbar;
@synthesize pickerToolbar;
@synthesize btnTranslate;
@synthesize adViewController;
@synthesize spinnerAlert;

-(IBAction) btnTranslatePressed:(id)sender
{
	if ([self.txtTextView.text length]>0)
	{
		Reachability* reachability = [Reachability reachabilityWithHostName:@"www.softcatala.org"];
		NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
		
		if(remoteHostStatus == NotReachable) 
		{ 
			NSLog(@"Internet not reachable");
			UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error de connexió" message: @"No es pot connectar amb el servidor" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];		
			[someError show];
			[someError release];
			return;
		}
		spinnerAlert=[[[UIAlertView alloc] initWithTitle:@"" message:@"Traduint" delegate:self cancelButtonTitle:nil otherButtonTitles:nil] autorelease];
		[spinnerAlert show];
		UIActivityIndicatorView *spinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.center=CGPointMake(spinnerAlert.bounds.size.width/2,spinnerAlert.bounds.size.height-50);
		[spinner startAnimating];
		[spinnerAlert addSubview:spinner];
		[spinner release];
		[self performSelector:@selector(translate) withObject:nil afterDelay:0.01];
	}
}
-(void)translate {

	[self translateText:self.txtTextView.text];
	if ([self.responseStatus isEqualToString:@"200"]) 
	{
		self.txtTranslatedText.text = self.translatedText;		
	}
	[spinnerAlert dismissWithClickedButtonIndex:0 animated:YES];
} 
-(NSString*) getLanguageCodeByInt:(int)col
{
	NSString *code = [[NSString alloc] init];
	switch(col)
	{
		case 0:
			code = @"es|ca";
			break;
		case 1:
			code = @"es|ca_valencia";
			break;
		case 2:
			code = @"ca|es";
			break;
		case 3:
			code = @"en|ca";
			break;
		case 4:
			code = @"ca|en";
			break;
		case 5:
			code = @"fr|ca";
			break;
		case 6: 
			code = @"ca|fr";
			break;
		case 7: 
			code = @"pt|ca";
			break;
		case 8:
			code= @"ca|pt";
			break;
		default:
			code = @"es|ca";
			break;
	}
	[code release];
	return code;
}
-(void) translateText:(NSString *)text
{
	
	NSURL *url = [[NSURL alloc] initWithString:@"http://www.softcatala.org/apertium/json/translate"];
	NSLog(@"%@",text);
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:self.language forKey:@"langpair"];
	[request setPostValue:text forKey:@"q"];
	[request setPostValue:@"yes" forKey:@"markUnknown"];
	[request setPostValue:@"NWI0MjQwMzQzMDYxMzA2NDYzNjQ" forKey:@"key"];
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {
		NSData *responsedata = [request responseData];
		NSString *jsonString = [[NSString alloc] initWithData:responsedata encoding:NSUTF8StringEncoding];
		NSDictionary *diccionario = [jsonString JSONValue];				
		NSString *response = [request responseString];
		NSLog(@"Response: %@", response);
		self.translatedText = [NSString stringWithFormat:@"%@", [[diccionario objectForKey:@"responseData"] objectForKey:@"translatedText"] ];
		self.responseStatus = [NSString stringWithFormat:@"%@", [diccionario objectForKey:@"responseStatus"]];
		[jsonString release];
		NSLog(@"Translation: %@", translatedText);
		NSLog(@"Response status: %@", responseStatus);
	}
	else {
		NSLog(@"Error: %@",error);
		self.responseStatus = @"-1"; 
	}
	[url release];
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.txtTextView.layer.cornerRadius = 8;
	self.txtTextView.layer.borderWidth = 2.0;
	self.txtTextView.layer.borderColor = [[UIColor grayColor] CGColor];
	self.txtTextView.clipsToBounds = YES;
	
	self.txtTranslatedText.layer.cornerRadius = 8;
	self.txtTranslatedText.layer.borderWidth = 2.0;
	self.txtTranslatedText.layer.borderColor = [[UIColor grayColor] CGColor];
	self.txtTranslatedText.clipsToBounds = YES;
	
	languagesArray = [[NSMutableArray alloc] init];
	[languagesArray addObject:@"Castellà >> Català"];
	[languagesArray addObject:@"Castellà >> Valencià"];
	[languagesArray addObject:@"Català >> Castellà"];
	[languagesArray addObject:@"Anglès >> Català"];
	[languagesArray addObject:@"Català >> Anglès"];
	[languagesArray addObject:@"Francès >> Català"];
	[languagesArray addObject:@"Català >> Francès"];
	[languagesArray addObject:@"Portuguès >> Català"];
	[languagesArray addObject:@"Català >> Portuguès"];
	
	self.language = [[NSString alloc] initWithString: @"es|ca"];
	self.view.backgroundColor = [[UIColor alloc] initWithRed:229.0/255.0 green:227.0/255.0 blue:216.0/255.0 alpha:1.0]; //#E5E3D8
	self.mainToolbar.tintColor = [[UIColor alloc] initWithRed:138.0/255.0 green:138.0/255.0 blue:138.0/255.0 alpha:1.0]; 
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(IBAction)btnKeyboardDonePressed:(id)sender
{
	[txtTextView resignFirstResponder];
	self.keyboardToolbar.hidden = YES;
	self.mainToolbar.hidden = NO;
	self.btnLanguage.enabled = YES;
}

-(IBAction)btnKeyboardCancelPressed:(id)sender
{
	[txtTextView resignFirstResponder];
	self.keyboardToolbar.hidden = YES;
	self.mainToolbar.hidden = NO;
	self.txtTextView.text = self.txtTextViewUndo;
	self.btnLanguage.enabled = YES;	
}

-(IBAction)btnPickerDonePressed:(id)sender
{
	self.pickerView.hidden = YES;
	self.pickerToolbar.hidden = YES;
	self.txtTextView.editable = YES;
	self.btnTranslate.enabled = YES;
	[self.btnLanguage setTitle: [self.languagesArray objectAtIndex:[pickerView selectedRowInComponent:0]] forState:UIControlStateNormal];
	self.adViewController.view.hidden = NO;
}
-(IBAction)btnPickerCancelPressed:(id)sender
{
	self.pickerView.hidden = YES;
	self.pickerToolbar.hidden = YES;
	self.txtTextView.editable = YES;
	self.btnTranslate.enabled = YES;
	self.adViewController.view.hidden = NO;
}

-(IBAction)btnChangeLanguagePressed:(id)sender
{
	if (pickerView.hidden == YES)
	{
		pickerView.hidden = NO;
		self.pickerToolbar.hidden = NO;
		self.keyboardToolbar.hidden = YES;
		self.txtTextView.editable = NO;
		self.navigationItem.rightBarButtonItem.enabled = NO;
		self.btnTranslate.enabled = NO;
		self.adViewController.view.hidden = YES;
	}
}

#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

	self.language = [self getLanguageCodeByInt:row];
}

#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	
    return [languagesArray objectAtIndex:row];
	
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	
    return [languagesArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	
    return 1;	
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	self.keyboardToolbar.hidden = NO;
	self.mainToolbar.hidden = YES;
	self.txtTextViewUndo = self.txtTextView.text;
	self.btnLanguage.enabled = NO;
	
}
- (void)dealloc {
    [super dealloc];
	[txtTextViewUndo release];
	[txtTranslatedText release];
	[translatedText release];
	[responseStatus release];
	[txtTextView release];
	[pickerView release];
	[languagesArray release];
	[language release];
	[btnLanguage release];
	[keyboardToolbar release];
	[mainToolbar release];
	[pickerToolbar release];
	[btnTranslate release];
	[adViewController release];
}

@end
