//
//  ChatViewCell.h
//  PinkyApp
//
//  Created by mohamed on 23/04/15.
//  Copyright (c) 2015 Arsalan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *user_image;
@property (nonatomic, strong) IBOutlet UILabel *user_name;
@property (nonatomic, strong) IBOutlet UILabel *comment;
@property (nonatomic, strong) IBOutlet UIView *chatView;
@property (nonatomic, strong) IBOutlet UILabel *time;
@property (nonatomic, strong) IBOutlet UIImageView *mediaImage;

@end
