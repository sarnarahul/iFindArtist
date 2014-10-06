//
//  CustomTableViewCell.m
//  iFindArtists
//
//  Created by Rahul Sarna on 21/04/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

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
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIColor* mainColor = [UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
    UIColor* neutralColor = [UIColor colorWithRed:0.7 green:0.3 blue:0.8 alpha:1.0];
    
    NSString* fontName = @"GillSans-Italic";
    NSString* boldFontName = @"GillSans-Bold";
    
    self.photoTitle.textColor =  mainColor;
    self.photoTitle.font =  [UIFont fontWithName:boldFontName size:14.0f];
    
    self.photoSubtitle.textColor =  neutralColor;
    self.photoSubtitle.font =  [UIFont fontWithName:fontName size:12.0f];
    
    self.contentView.layer.cornerRadius = 3.0f;
    self.contentView.clipsToBounds = YES;
    
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.clipsToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
