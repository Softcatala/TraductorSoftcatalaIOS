//
//  FavouritesViewController.m
//  Softcatala
//
//  Created by Marcos Grau on 23/05/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "FavouritesViewController.h"
#import "TranslationArchiver.h"
#import "TranslationCell.h"
#import "Translation.h"

static NSString *favouriteCellIdentifier = @"favouriteCell";

@interface FavouritesViewController () <UITableViewDataSource, UITableViewDelegate, TranslationCellDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TranslationArchiver *archiver;
@property (strong, nonatomic) IBOutlet UIButton *btnEditOk;
@property (strong, nonatomic) IBOutlet UIButton *btnRemoveAll;
@property (strong, nonatomic) NSArray *favourites;

- (IBAction)editTable:(id)sender;
- (IBAction)removeAll:(id)sender;

@end

@implementation FavouritesViewController

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
    [self loadFavourites];
    [self.tableView reloadData];
}

- (void)loadFavourites
{
    _archiver = [[TranslationArchiver alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Translation *translation = (Translation *)evaluatedObject;
        return [translation favourite];
    }];
    _favourites = [_archiver.translations filteredArrayUsingPredicate:predicate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)translationCell:(TranslationCell *)translationCell favouriteButtonPressed:(UIButton *)button
{
    NSIndexPath *cellIndexPath = [_tableView indexPathForCell:translationCell]; //translationCell.indexPath;
    Translation *translation = _favourites[cellIndexPath.row];
    [translation setFavourite:button.selected];

    [_archiver updateTranslation:translation];
    [self loadFavourites];
    [_tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_favourites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TranslationCell *cell = [tableView dequeueReusableCellWithIdentifier:favouriteCellIdentifier forIndexPath:indexPath];
    Translation *translation = _favourites[indexPath.row];
    
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
        Translation *translation = _favourites[indexPath.row];
        [_archiver removeTranslation:translation];
        [self loadFavourites];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

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
        for (Translation *translation in _favourites) {
            [_archiver removeTranslation:translation];
        }
        [self loadFavourites];
        [_tableView reloadData];
    }
}
@end
