//
//  ShowPhotoView.m
//  KeyEyes
//
//  Created by 蒋一博 on 16/3/22.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "ShowPhotoView.h"
#import <AVOSCloud/AVOSCloud.h>
//非wifi提示
#import "Reachability.h"
#import "HHAlertView.h"

@interface ShowPhotoView()

@property (nonatomic,strong) NSMutableArray *putOnArr;
@property (nonatomic,assign) BOOL islike;


@end


@implementation ShowPhotoView

- (instancetype)initWithFrame:(CGRect)frame offsetY:(CGFloat)offsetY
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        //图片
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView = [[UIImageView alloc]init];
        _showImageView.bounds = CGRectMake(0,0, 500, 313);
        _showImageView.center = CGPointMake(375/2 + 37.5/2, offsetY + 100);
        //_showImageView.backgroundColor = [UIColor orangeColor];
        _showImageView.alpha = 0.0;
        
        //背后模糊板
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        _visualEffectView.alpha = 0.0;//0.8
        [_visualEffectView setFrame:_showImageView.frame];
        
        //播放按钮
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.frame = CGRectMake(175/2, 240 / 2, 200, 200);
        [playButton addTarget:self action:@selector(playerStart) forControlEvents:UIControlEventTouchUpInside];
        [playButton setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
        
        
        
        [self addSubview:_visualEffectView];
        [self addSubview:_showImageView];
        [self addSubview:playButton];

    }
    return self;
}

- (void)photoAnimation{
    //创建文本栏
    [self initLabel];
    //出现动画
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _showImageView.alpha = 1;
        _showImageView.frame = CGRectMake(-37.5, 65, 500, 313);
        _visualEffectView.alpha = 1;
        [_visualEffectView setFrame:CGRectMake(0, 0, 375, 667)];
        
    } completion:nil];
}

- (void)initLabel{
    
    //标题
    UILabel *imageName = [[UILabel alloc]initWithFrame:CGRectMake(20, 400, 335, 40)];
    imageName.text = _theImageName;
    imageName.textColor = [UIColor whiteColor];
    imageName.backgroundColor=[UIColor clearColor];
    imageName.textAlignment = NSTextAlignmentLeft;
    imageName.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [_visualEffectView addSubview:imageName];
    //分割线
    UILabel *cutLine = [[UILabel alloc]initWithFrame:CGRectMake(20, 440, 335, 1)];
    cutLine.backgroundColor = [UIColor whiteColor];
    [_visualEffectView addSubview:cutLine];
    //文本
    UILabel *aboutImage = [[UILabel alloc]initWithFrame:CGRectMake(20, 450, 335, 210)];
    aboutImage.backgroundColor = [UIColor clearColor];
    aboutImage.text = _aboutImage;
    aboutImage.numberOfLines = 0;
    aboutImage.textColor = [UIColor whiteColor];
    aboutImage.backgroundColor=[UIColor clearColor];
    aboutImage.textAlignment = NSTextAlignmentLeft;
    aboutImage.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [aboutImage sizeToFit];
    [_visualEffectView addSubview:aboutImage];
    
    //like按钮
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton.frame = CGRectMake(20, 567, 80, 80);
   
    //是否被like判断
    
    NSMutableArray *saveArr = [[AVUser currentUser] objectForKey:@"like"];
    if (!saveArr) {
        //初始状态,
        saveArr = [NSMutableArray array];
        [_likeButton setImage:[UIImage imageNamed:@"likeG"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"likeR"] forState:UIControlStateHighlighted];
        [_likeButton addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        //再次使用状态
        _islike = 0;
        for (NSArray *getArr in saveArr) {
            if ([getArr[0] isEqualToString:_theImageName]) {
                //被喜欢过
                //NSLog(@"like");
                _islike = 1;
                [_likeButton setImage:[UIImage imageNamed:@"likeR"] forState:UIControlStateNormal];
            }
        }
        
        if (!_islike) {
            //NSLog(@"unlike");
            [_likeButton setImage:[UIImage imageNamed:@"likeG"] forState:UIControlStateNormal];
            [_likeButton setImage:[UIImage imageNamed:@"likeR"] forState:UIControlStateHighlighted];
            [_likeButton addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    
    [_visualEffectView addSubview:_likeButton];
    
    //like文本
    UILabel *aboutLike = [[UILabel alloc]initWithFrame:CGRectMake(100, 587, 100, 40)];
    aboutLike.backgroundColor = [UIColor clearColor];
    aboutLike.text = @"If you like  Just Like";
    aboutLike.numberOfLines = 2;
    aboutLike.textColor = [UIColor whiteColor];
    aboutLike.backgroundColor=[UIColor clearColor];
    aboutLike.textAlignment = NSTextAlignmentLeft;
    aboutLike.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [_visualEffectView addSubview:aboutLike];
    
    //网络状态判定
    [self isConnectionAvailable];
}

- (void)playerStart{
    self.playerHandle(_playerUrl);
    
}

- (void)playerWithURL:(playerBlock) backUrl{
    self.playerHandle = [backUrl copy];
}

- (void)like{
    
    //like交互动画
    UIButton *moveLike = [UIButton buttonWithType:UIButtonTypeCustom];
    moveLike.bounds = CGRectMake(0, 0, 80, 80);
    moveLike.center = CGPointMake(60, 607);
    [moveLike setImage:[UIImage imageNamed:@"likeG"] forState:UIControlStateNormal];
    [_visualEffectView addSubview:moveLike];
    
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:0 animations:^{
            moveLike.bounds = CGRectMake(0, 0, 120, 120);
            moveLike.alpha = 0;
        [_likeButton setImage:[UIImage imageNamed:@"likeR"] forState:UIControlStateNormal];
        [moveLike setImage:[UIImage imageNamed:@"likeR"] forState:UIControlStateNormal];
    } completion:nil];
    //上传数据到leancloud服务器
    //因为之前已经判定过是否喜欢过，而去喜欢过之后无法再次点击，因此这里没必要做判定是否喜欢过
    NSArray *oneArr = @[_theImageName,_aboutImage,_imageUrl,_playerUrl];
    NSMutableArray *saveArr = [[AVUser currentUser] objectForKey:@"like"];
    if (!saveArr) {
        saveArr = [NSMutableArray array];
        [saveArr addObject:oneArr];
    }else{
        [saveArr addObject:oneArr];
    }
   
    [[AVUser currentUser] setObject:saveArr forKey:@"like"];
    [[AVUser currentUser] saveInBackground];
    
    
}

#pragma mark - 非wifi判定
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
           // NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
          //  NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            [self noWifi];
          //  NSLog(@"3G");
            break;
    }
    if (!isExistenceNetwork) {
      //  NSLog(@"无网络连接");
    }
    return isExistenceNetwork;
}

- (void)noWifi{
    [HHAlertView showAlertWithStyle:HHAlertStyleWraing inView:self Title:@"Tips" detail:@"There is no Wi-Fi,You'd better don't see this" cancelButton:nil Okbutton:@"OK"];
    
}

@end
