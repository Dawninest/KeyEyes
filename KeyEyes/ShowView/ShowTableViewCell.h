//
//  ShowTableViewCell.h
//  KeyEyes
//
//  Created by 蒋一博 on 16/3/21.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, assign, readwrite) CGPoint imageOffset;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (CGFloat)cellOffset;

@end
