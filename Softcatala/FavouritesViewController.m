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
        [_archiver removeAllTranslations];
        [self.tableView setEditing:NO animated:YES];
        [self changeTableToEditing:NO];
        [_tableView reloadData];
    }
}
@end
