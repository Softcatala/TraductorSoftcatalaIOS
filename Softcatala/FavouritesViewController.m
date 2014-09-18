//
//  FavouritesViewController.m
//  Softcatala
//
//  Created by Marcos Grau on 23/05/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "FavouritesViewController.h"
#import "FavouriteArchiver.h"
#import "TranslationCell.h"
#import "Translation.h"
#import "TranslationViewController.h"
#import "LocalizeHelper.h"

static NSString *favouriteCellIdentifier = @"favouriteCell";

@interface FavouritesViewController () <UITableViewDataSource, UITableViewDelegate, TranslationCellDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FavouriteArchiver *archiver;
@property (strong, nonatomic) IBOutlet UIButton *btnEditOk;
@property (strong, nonatomic) IBOutlet UIButton *btnRemoveAll;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)editTable:(id)sender;
- (IBAction)removeAll:(id)sender;
- (IBAction)selectedListChanged:(id)sender;

@end

@implementation FavouritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localizeToChoosenLanguage) name:kLanguageNotification object:nil];
    [self localizeToChoosenLanguage];
    [_btnRemoveAll setHidden:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.tabBarController.tabBar setHidden:YES];
        self.tableView.tableFooterView = [UIView new];
        [_segmentedControl setSelectedSegmentIndex:1];
    }
    
    [self localizeToChoosenLanguage];
    [self.tableView setEditing:NO animated:YES];
    [self changeTableToEditing:NO];
    _archiver = [[FavouriteArchiver alloc] init];

    [self.tableView reloadData];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.tableView.alpha = 0.0;
        if ([_archiver.translations count] > 0) {
            self.tableView.tableFooterView = [UIView new];
        } else {
            self.tableView.tableFooterView = nil;
            [self performTableViewFadeOut];
        }
        [self performTableViewAnimation];
    }
    
}

- (void)performTableViewFadeOut
{
    [UIView animateWithDuration:1.0 animations:^{
        self.tableView.alpha = 1.0;
    } completion:nil];
}

- (void)performTableViewAnimation
{
    // Store a delta timing variable so I can tweak the timing delay
    // between each row’s animation and some additional
    CGFloat diff = .05;
    NSArray *cells = [self.tableView visibleCells];
    
    // Iterate across the rows and translate them down off the screen
    for (NSUInteger a = 0; a < [cells count]; a++) {
        UITableViewCell *cell = [cells objectAtIndex:a];
        if ([cell isKindOfClass:[UITableViewCell class]]) {
            
            // Move each cell off the bottom of the screen by translating its Y position
            cell.transform = CGAffineTransformMakeTranslation(cell.frame.size.width, 0);
        }
    }
    
    // Now that all rows are off the screen, make the tableview opaque again
    self.tableView.alpha = 1.0f;
    
    // Animate each row back into place
    for (NSUInteger b = 0; b < [cells count]; b++) {
        UITableViewCell *cell = [cells objectAtIndex:b];
        
        [UIView animateWithDuration:1.0 delay:diff*b usingSpringWithDamping:0.77
              initialSpringVelocity:0 options:0 animations:^{
                  cell.transform = CGAffineTransformMakeTranslation(0, 0);
              } completion:NULL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)translationCell:(TranslationCell *)translationCell favouriteButtonPressed:(UIButton *)button
{
    NSIndexPath *cellIndexPath = [_tableView indexPathForCell:translationCell];
    Translation *translation = _archiver.translations[cellIndexPath.row];
    [translation setFavourite:button.selected];
    [_archiver updateTranslation:translation];
    [_tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if ([_archiver.translations count] == 0) {
        [UIView animateWithDuration:.0 delay:.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.tableView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.tableView.tableFooterView = nil;
            [self performTableViewFadeOut];
        }];
    }
}

- (IBAction)selectedListChanged:(id)sender {
    UISegmentedControl *segmentedControl = sender;
    [self.tabBarController setSelectedIndex:segmentedControl.selectedSegmentIndex];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_archiver.translations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TranslationCell *cell = [tableView dequeueReusableCellWithIdentifier:favouriteCellIdentifier forIndexPath:indexPath];
    Translation *translation = _archiver.translations[indexPath.row];
    
    cell.sourceLabel.text = translation.source;
    cell.translationLabel.text = translation.translation;
    [cell.btnFavourite setSelected:translation.favourite];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        TranslationViewController *translationVC = (TranslationViewController *)self.tabBarController.parentViewController;
        Translation *translation = _archiver.translations[indexPath.row];
        [translationVC loadTranslation:translation];
        
    } else {
        TranslationViewController *translationVC = self.tabBarController.viewControllers[0];
        Translation *translation = _archiver.translations[indexPath.row];
        [translationVC loadTranslation:translation];
        [self.tabBarController setSelectedIndex:0];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Translation *translation = _archiver.translations[indexPath.row];
        [_archiver removeTranslation:translation];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)editTable:(id)sender {
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    [self changeTableToEditing:[_tableView isEditing]];
}

- (IBAction)removeAll:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizedString(@"ActionSheetCancel") destructiveButtonTitle:LocalizedString(@"ActionSheetRemoveAll") otherButtonTitles:nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)removeAlliPAd:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:LocalizedString(@"ActionSheetRemoveAll") delegate:self cancelButtonTitle:LocalizedString(@"ButtonRemoveAllTable") otherButtonTitles:LocalizedString(@"ActionSheetCancel"), nil];
    [alertView show];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        for (Translation *translation in _archiver.translations) {
            [_archiver removeTranslation:translation];
        }
        [self.tableView setEditing:NO animated:YES];
        [self changeTableToEditing:NO];
        [_tableView reloadData];
    }
}

- (void)changeTableToEditing:(BOOL)editing
{
    if (editing) {
        [_btnEditOk setTitle:LocalizedString(@"ButtonEditOkTable") forState:UIControlStateNormal];
        [_btnEditOk setTitle:LocalizedString(@"ButtonEditOkTable") forState:UIControlStateHighlighted];
        [_btnRemoveAll setHidden:NO];
    } else {
        [_btnEditOk setTitle:LocalizedString(@"ButtonEditTable") forState:UIControlStateNormal];
        [_btnEditOk setTitle:LocalizedString(@"ButtonEditTable") forState:UIControlStateHighlighted];
        [_btnRemoveAll setHidden:YES];
        
    }
}
#pragma mark Localization choosen Language
- (void)localizeToChoosenLanguage
{
    [_btnRemoveAll setTitle:LocalizedString(@"ButtonRemoveAllTable") forState:UIControlStateNormal];
    [_btnRemoveAll setTitle:LocalizedString(@"ButtonRemoveAllTable") forState:UIControlStateHighlighted];
    [_btnEditOk setTitle:LocalizedString(@"ButtonEditTable") forState:UIControlStateNormal];
    [_btnEditOk setTitle:LocalizedString(@"ButtonEditTable") forState:UIControlStateHighlighted];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [_segmentedControl setTitle:LocalizedString(@"ButtonHistoric") forSegmentAtIndex:0];
        [_segmentedControl setTitle:LocalizedString(@"ButtonFavourites") forSegmentAtIndex:1];
    }
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        for (Translation *translation in _archiver.translations) {
            [_archiver removeTranslation:translation];
        }
        [self.tableView setEditing:NO animated:YES];
        [self changeTableToEditing:NO];
        [_tableView reloadData];
    }

}
@end
