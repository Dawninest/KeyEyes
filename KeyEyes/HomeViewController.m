//
//  HomeViewController.m
//  KeyEye
//
//  Created by 蒋一博 on 16/4/1.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "HomeViewController.h"
#import "ShowViewController.h"
#import "LeftViewController.h"

@interface HomeViewController ()
{
    BOOL _isChange;
    BOOL _isH;
}

@property (nonatomic, strong) UIButton *leftButton;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}


- (id)initWithShowVC:(ShowViewController *)showVC leftVC:(LeftViewController *)leftVC{
    
    if (self = [super init]) {
        
        [self addChildViewController:leftVC];
        UINavigationController *showNC = [[UINavigationController alloc] initWithRootViewController:showVC];
        [self addChildViewController:showNC];
        
        leftVC.view.frame = CGRectMake(0, 0, 270, [UIScreen mainScreen].bounds.size.height);
        showNC.view.frame = [UIScreen mainScreen].bounds;
        
        [self.view addSubview:leftVC.view];
        [self.view addSubview:showNC.view];
        
        [self.navigationController.navigationBar setHidden:YES];
        self.navigationController.navigationBar.barTintColor  = [UIColor whiteColor];
        
        //自定义navigationItem
        UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 44)];
        UIImageView *navImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-44-b"]];
        navImage.frame = CGRectMake( -8, 0, 375, 44);
        [navView addSubview:navImage];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(- 6 , 0, 375, 44)];
        title.text = @"-key         eye-";
        title.font = [UIFont fontWithName:@"Copperplate" size:25];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor colorWithRed:0.21 green:0.60 blue:0.93 alpha:1.00];
        self.navigationItem.titleView = title;
        [navView addSubview:title];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(3, 7, 28, 28);
        [_leftButton setImage:[UIImage imageNamed:@"person"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:_leftButton];
        
        
        
        self.navigationItem.titleView = navView;
        
        
        //显示左栏时，右边剩下部分的遮罩
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        _visualEffectView.alpha = 0.5;
        [_visualEffectView setFrame:CGRectMake(-105, 0 ,105, 667)];
        [self.view addSubview:_visualEffectView];
        
        //添加遮罩点击手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftAction:)];
        [_visualEffectView addGestureRecognizer:tapGes];

        
    }
    
    return self;
}

//左边按钮事件: rightVC 和 centerNC 向右偏移
- (void)leftAction:(UIButton *)sender {
    
    UINavigationController *centerNC = self.childViewControllers.lastObject;
    LeftViewController *leftVC = self.childViewControllers.firstObject;
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
        if ( centerNC.view.center.x != self.view.center.x ) {
            leftVC.view.frame = CGRectMake(0, 0, 270, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
             [_visualEffectView setFrame:CGRectMake( -105, 0,105, 667)];
            [_leftButton setImage:[UIImage imageNamed:@"person"] forState:UIControlStateNormal];
            _isChange = !_isChange;
            return;
        }else{
            [_visualEffectView setFrame:CGRectMake(270, 0 ,105, 667)];
            [_leftButton setImage:[UIImage imageNamed:@"mune"] forState:UIControlStateNormal];
            centerNC.view.frame = CGRectMake(270, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
    }completion:nil];
}


@end
