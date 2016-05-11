//
//  ShowPhotoView.h
//  KeyEyes
//
//  Created by 蒋一博 on 16/3/22.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^playerBlock)(NSString *URL);

@interface ShowPhotoView : UIView

@property (nonatomic,strong) playerBlock playerHandle;

@property (nonatomic,strong) UIImageView *showImageView;

@property (nonatomic,strong) UIVisualEffectView *visualEffectView;

@property (nonatomic,strong) NSString *theImageName;

@property (nonatomic,strong) NSString *aboutImage;

@property (nonatomic,strong) NSString *playerUrl;

@property (nonatomic,strong) UIButton *likeButton;

@property (nonatomic,strong) NSString *imageUrl;



- (instancetype)initWithFrame:(CGRect)frame offsetY:(CGFloat)offsetY;
- (void)photoAnimation;

- (void)playerWithURL:(playerBlock) backUrl;

@end
