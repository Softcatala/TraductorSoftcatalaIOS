//
//  TranslationCell.h
//  Softcatala
//
//  Created by marcos on 21/05/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TranslationCellDelegate;

@interface TranslationCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *btnFavourite;
@property (nonatomic, strong) IBOutlet UILabel *sourceLabel;
@property (nonatomic, strong) IBOutlet UILabel *translationLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak) id<TranslationCellDelegate> delegate;

@end

@protocol TranslationCellDelegate

- (void)translationCell:(TranslationCell *)translationCell favouriteButtonPressed:(UIButton *)button;

@end