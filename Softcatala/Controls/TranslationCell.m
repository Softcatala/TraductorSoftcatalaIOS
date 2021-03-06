//
//  TranslationCell.m
//  Softcatala
//
//  Created by marcos on 21/05/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "TranslationCell.h"

@implementation TranslationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [_btnFavourite addTarget:self action:@selector(favouriteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)favouriteButtonPressed:(id)sender
{
    [_btnFavourite setSelected:!_btnFavourite.selected];
    [self.delegate translationCell:self favouriteButtonPressed:sender];
    
    _btnFavourite.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _btnFavourite.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];

}
@end
