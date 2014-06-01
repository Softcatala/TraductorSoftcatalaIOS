//
//  HistoricTableViewController.m
//  Softcatala
//
//  Created by marcos on 20/05/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "HistoricTableViewController.h"
#import "HistoricArchiver.h"
#import "Translation.h"
#import "TranslationCell.h"
#import "TranslationViewController.h"

static NSString *translationCellIdentifier = @"translationCell";

@interface HistoricTableViewController () <UITableViewDataSource, UITableViewDelegate, TranslationCellDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HistoricArchiver *archiver;
@property (strong, nonatomic) IBOutlet UIButton *btnEditOk;
@property (strong, nonatomic) IBOutlet UIButton *btnRemoveAll;

- (IBAction)editTable:(id)sender;
- (IBAction)removeAll:(id)sender;

@end

@implementation HistoricTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_btnRemoveAll setHidden:YES];
    [_btnRemoveAll setTitle:NSLocalizedString(@"ButtonRemoveAllTable", nil) forState:UIControlStateNormal];
    [_btnRemoveAll setTitle:NSLocalizedString(@"ButtonRemoveAllTable", nil) forState:UIControlStateHighlighted];
    [_btnEditOk setTitle:NSLocalizedString(@"ButtonEditTable", nil) forState:UIControlStateNormal];
    [_btnEditOk setTitle:NSLocalizedString(@"ButtonEditTable", nil) forState:UIControlStateHighlighted];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView setEditing:NO animated:YES];
    [self changeTableToEditing:NO];
    _archiver = [[HistoricArchiver alloc] init];
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
    TranslationCell *cell = [tableView dequeueReusableCellWithIdentifier:translationCellIdentifier forIndexPath:indexPath];
    Translation *translation = _archiver.translations[indexPath.row];
    
    cell.sourceLabel.text = translation.source;
    cell.translationLabel.text = translation.translation;
    [cell.btnFavourite setSelected:translation.favourite];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TranslationViewController *translationVC = self.tabBarController.viewControllers[0];
    Translation *translation = _archiver.translations[indexPath.row];
    [translationVC loadTranslation:translation];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)editTable:(id)sender {
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    [self changeTableToEditing:[_tableView isEditing]];
}

- (IBAction)removeAll:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ActionSheetCancel", nil) destructiveButtonTitle:NSLocalizedString(@"ActionSheetRemoveAll", nil) otherButtonTitles:nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [_archiver removeAllTranslations];
        [self.tableView setEditing:NO animated:YES];
        [self changeTableToEditing:NO];
        [_tableView reloadData];
    }
}

- (void)changeTableToEditing:(BOOL)editing
{
    if (editing) {
        [_btnEditOk setTitle:NSLocalizedString(@"ButtonEditOkTable", nil) forState:UIControlStateNormal];
        [_btnEditOk setTitle:NSLocalizedString(@"ButtonEditOkTable", nil) forState:UIControlStateHighlighted];
        [_btnRemoveAll setHidden:NO];
    } else {
        [_btnEditOk setTitle:NSLocalizedString(@"ButtonEditTable", nil) forState:UIControlStateNormal];
        [_btnEditOk setTitle:NSLocalizedString(@"ButtonEditTable", nil) forState:UIControlStateHighlighted];
        [_btnRemoveAll setHidden:YES];
        
    }
}
@end
