//
//  MyPlayerViewController.m
//  KeyEye
//
//  Created by 蒋一博 on 16/3/28.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "MyPlayerViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface MyPlayerViewController ()

@property (nonatomic,strong)AVPlayerViewController *avPlayer;

@end

@implementation MyPlayerViewController

- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor grayColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    UIImageView *coverBlurred = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coverBlurred.jpg"]];
    coverBlurred.frame = CGRectMake(0, 0, 777, 1242);
    [self.view addSubview:coverBlurred];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 10, 60, 60);
    [backButton addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.backgroundColor = [UIColor clearColor];
    [playButton setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    playButton.bounds = CGRectMake(0, 0, 200, 200);
    playButton.center = CGPointMake(667/2, 375/2);
    [playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
}

- (void)play{
    
    
    
    _avPlayer = [[AVPlayerViewController alloc]init];
    //_avPlayer.player = self;
    NSURL *videoUrl = [NSURL URLWithString:_playerUrl];
    _avPlayer.player = [[AVPlayer alloc]initWithURL:videoUrl];
    _avPlayer.view.frame = self.view.frame;
    
    [self addChildViewController:_avPlayer];
    [self.view addSubview:_avPlayer.view];
    
    [_avPlayer.player play];
    
}

- (void)backHome{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}




@end
