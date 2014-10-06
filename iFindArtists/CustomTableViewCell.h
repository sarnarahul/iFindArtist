//
//  CustomTableViewCell.h
//  iFindArtists
//
//  Created by Rahul Sarna on 21/04/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *photoTitle;
@property (strong, nonatomic) IBOutlet UILabel *photoSubtitle;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;


@end
