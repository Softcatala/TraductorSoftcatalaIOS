//
//  ProgressHud.m
//  Softcatala
//
//  Created by marcos on 21/04/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "ProgressHud.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation ProgressHud

+ (void)show
{
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:181.0/255.0 green:0.0 blue:39.0/255.0 alpha:1.0]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}
@end
