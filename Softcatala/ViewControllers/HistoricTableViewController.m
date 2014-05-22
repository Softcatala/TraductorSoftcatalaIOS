//
//  HistoricTableViewController.m
//  Softcatala
//
//  Created by marcos on 20/05/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "HistoricTableViewController.h"
#import "TranslationArchiver.h"
#import "Translation.h"
#import "TranslationCell.h"

static NSString *translationCellIdentifier = @"translationCell";

@interface HistoricTableViewController () <UITableViewDataSource, UITableViewDelegate, TranslationCellDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TranslationArchiver *archiver;
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
    _archiver = [[TranslationArchiver alloc] init];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)translationCell:(TranslationCell *)translationCell favouriteButtonPressed:(UIButton *)button
{
    Translation *translation = _archiver.translations[translationCell.indexPath.row];
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


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Translation *translation = _archiver.translations[indexPath.row];
        [_archiver removeTranslation:translation];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editTable:(id)sender {
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    if ([_tableView isEditing]) {
        [_btnEditOk setTitle:NSLocalizedString(@"ButtonEditOkTable", nil) forState:UIControlStateNormal];
        [_btnEditOk setTitle:NSLocalizedString(@"ButtonEditOkTable", nil) forState:UIControlStateHighlighted];
        [_btnRemoveAll setHidden:NO];
    } else {
        [_btnEditOk setTitle:NSLocalizedString(@"ButtonEditTable", nil) forState:UIControlStateNormal];
        [_btnEditOk setTitle:NSLocalizedString(@"ButtonEditTable", nil) forState:UIControlStateHighlighted];
        [_btnRemoveAll setHidden:YES];
        
    }
}

- (IBAction)removeAll:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ActionSheetCancel", nil) destructiveButtonTitle:NSLocalizedString(@"ActionSheetRemoveAll", nil) otherButtonTitles:nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        for (Translation *translation in _archiver.translations) {
            [_archiver removeTranslation:translation];
        }
        [_tableView reloadData];
    }
 }
@end
