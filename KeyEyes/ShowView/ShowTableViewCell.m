//
//  ShowTableViewCell.m
//  KeyEyes
//
//  Created by 蒋一博 on 16/3/21.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "ShowTableViewCell.h"

@interface ShowTableViewCell()




@end

@implementation ShowTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.clipsToBounds = YES;
    _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(- 37.5, 0, 500, 313)];
    //_showImageView.backgroundColor = [UIColor redColor];
    _showImageView.contentMode = UIViewContentModeScaleAspectFill;
    _showImageView.clipsToBounds = NO;
    [self.contentView addSubview:_showImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
    _titleLabel.backgroundColor = [UIColor colorWithRed:0.06 green:0.04 blue:0.13 alpha:0.25];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [self.contentView addSubview:_titleLabel];
    


}

- (void)setImage:(UIImage *)image
{
    _showImageView.image = image;
    [self setImageOffset:_imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    _imageOffset = imageOffset;
    CGRect frame = _showImageView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    _showImageView.frame = offsetFrame;
    
}

//出现动画3d旋转
- (CGFloat)cellOffset {
    
    CGRect centerToWindow = [self convertRect:self.bounds toView:self.window];
    CGFloat centerY = CGRectGetMidY(centerToWindow);
    CGPoint windowCenter = self.superview.center;
    CGFloat cellOffsetY = centerY - windowCenter.y;
    CGFloat offsetDig =  cellOffsetY / self.superview.frame.size.height *2;
    CGFloat offset =  -offsetDig * (375/1.7 - 250)/2;
    
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
    self.showImageView.transform = transY;
    
    return offset;
}





@end

