//
//  ViewController.m
//  KeyEyes
//
//  Created by 蒋一博 on 16/3/19.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "ViewController.h"

#import "HomeViewController.h"
#import "ShowViewController.h"
#import "LeftViewController.h"


#import "UIImage+GIF.h"
#import "ViewController.h"
#import "HyTransitions.h"
#import "HyLoglnButton.h"

#import <AVOSCloud/AVOSCloud.h>

//网络连接判定
#import "Reachability.h"
//三方提示框
#import "HHAlertView.h"




@interface ViewController ()<UIViewControllerTransitioningDelegate>

@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UIView *onScroll;
@property (strong, nonatomic)  NSTimer *timer;
@property (strong, nonatomic)  UIImageView *logoImage;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UIVisualEffectView *visualEffectView;
//登录
@property (strong, nonatomic)  UITextField *userNameTextField;
@property (strong, nonatomic)  UITextField *passWordTextField;
@property (strong, nonatomic)  HyLoglnButton *loginButton;
//注册
@property (strong, nonatomic)  UIButton *getRegister;
@property (strong, nonatomic)  UIButton *registerID;


@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];

#pragma mark - 基本
    //roll background
    _scrollView = [[UIScrollView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView.frame = self.view.frame;
    _scrollView.contentSize = CGSizeMake(3853/2, 1334/2);
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    //rollBackground上的遮罩
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backroll"]];
    imageView.frame = CGRectMake(0,0,3853/2, 1334/2);
    [_scrollView addSubview:imageView];
    
    //控制rollBackground滚动的timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(imageRoll) userInfo:nil repeats:YES];
    
    _onScroll = [[UIView alloc]initWithFrame:_scrollView.frame];
    _onScroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_onScroll];
    
    //logo
    _logoImage = [[UIImageView alloc]init];
    _logoImage.image = [UIImage imageNamed:@"logoW"];
    _logoImage.bounds = CGRectMake(0, 0, 214,143);
    _logoImage.center = CGPointMake(self.view.bounds.size.width / 2, 280);
    _logoImage.backgroundColor = [UIColor clearColor];
    
    //Name
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.bounds = CGRectMake(0, 0, 285,136);
    _nameLabel.center = CGPointMake(self.view.bounds.size.width / 2, 360);
    _nameLabel.text = @"-key eye-";
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.backgroundColor=[UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont fontWithName:@"Copperplate" size:30];
    
    //模糊遮罩
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    _visualEffectView.alpha = 0.0;//0.8
    [_visualEffectView setFrame:CGRectMake(0, 300, self.view.bounds.size.width, 0)];
    
#pragma mark - 登录
    //登录－帐号密码
    //用户名
    _userNameTextField = [[UITextField alloc]init];
    _userNameTextField.bounds = CGRectMake(0, 0, 280, 40);
    _userNameTextField.center = CGPointMake(self.view.bounds.size.width / 2, 240);
    _userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _userNameTextField.backgroundColor = [UIColor clearColor];
    _userNameTextField.alpha = 0.0;
    _userNameTextField.placeholder = @"user name";
    _userNameTextField.font = [UIFont fontWithName:@"Copperplate" size:20];
    _userNameTextField.textColor = [UIColor blackColor];
    _userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTextField.textAlignment = NSTextAlignmentCenter;
    _userNameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    //密码
    _passWordTextField = [[UITextField alloc]init];
    _passWordTextField.bounds = CGRectMake(0, 0, 280, 40);
    _passWordTextField.center = CGPointMake(self.view.bounds.size.width / 2, 290);
    _passWordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passWordTextField.backgroundColor = [UIColor clearColor];
    _passWordTextField.alpha = 0.0;
    _passWordTextField.placeholder = @"pass word";
    _passWordTextField.font = [UIFont fontWithName:@"Copperplate" size:20];
    _passWordTextField.textColor = [UIColor blackColor];
    _passWordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passWordTextField.secureTextEntry = YES;//密码隐藏
    _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordTextField.textAlignment = NSTextAlignmentCenter;
    _passWordTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
#pragma mark - 测试数据填充
    _userNameTextField.text = @"Dawninest";
    _passWordTextField.text = @"123";
    
#pragma mark - 自定义按钮 from third
    _loginButton = [[HyLoglnButton alloc] initWithFrame:CGRectMake(45, 450 - (40 + 80), [UIScreen mainScreen].bounds.size.width - 90, 40)];
    _loginButton.alpha = 0.0;
    [_loginButton setBackgroundColor:[UIColor colorWithRed:0.21 green:0.60 blue:0.93 alpha:1.00]];//
    _loginButton.titleLabel.font = [UIFont fontWithName:@"Copperplate" size:20];
    [_loginButton setTitle:@"open eyes" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(PresentViewController:) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark - 注册
    //注册－帐号密码
    //弹出注册的按钮
    _getRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    _getRegister.frame = CGRectMake(45, 380, [UIScreen mainScreen].bounds.size.width - 90, 40);
    _getRegister.titleLabel.font = [UIFont fontWithName:@"Copperplate" size:20];
    _getRegister.backgroundColor = [UIColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.00];
    _getRegister.layer.cornerRadius = 20;
    _getRegister.clipsToBounds = YES;
    _getRegister.alpha = 0;
    [_getRegister setTitle:@"get the key" forState:UIControlStateNormal];
    [_getRegister setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_getRegister addTarget:self action:@selector(getRegister:) forControlEvents:UIControlEventTouchUpInside];
    //确认注册
    _registerID = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerID.frame = CGRectMake(45, 330, [UIScreen mainScreen].bounds.size.width - 90, 40);
    _registerID.titleLabel.font = [UIFont fontWithName:@"Copperplate" size:20];
    _registerID.backgroundColor = [UIColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.00];
    _registerID.layer.cornerRadius = 20;
    _registerID.clipsToBounds = YES;
    _registerID.alpha = 0;
    [_registerID setTitle:@"use this key" forState:UIControlStateNormal];
    [_registerID setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_registerID addTarget:self action:@selector(registerID:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initializeDataSource];
    [self initializeInterface];
}

- (void)initializeDataSource
{
    //此登录界面暂时不设置登录数据网络请求验证
}

- (void)initializeInterface
{
    [self.view addSubview:_scrollView];
    
    //设置完背景之后
    [self.view bringSubviewToFront:_onScroll];
    [_onScroll addSubview:_logoImage];
    [_onScroll addSubview:_nameLabel];
    [_onScroll addSubview:_visualEffectView];
    //登录
    [self.view addSubview:_userNameTextField];
    [self.view addSubview:_passWordTextField];
    [self.view addSubview:_loginButton];
    //注册
    [self.view addSubview:_getRegister];
    [self.view addSubview:_registerID];
    
    //屏幕下方版权标示
    UILabel *about1 = [[UILabel alloc]init];
    about1.bounds = CGRectMake(0, 0, self.view.bounds.size.width,40);
    about1.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 40);
    about1.text = @"dawninest - darkForce";
    about1.textColor = [UIColor whiteColor];
    about1.backgroundColor=[UIColor clearColor];
    about1.textAlignment = NSTextAlignmentCenter;
    about1.font = [UIFont fontWithName:@"Copperplate" size:20];
    [self.view addSubview:about1];
    
    UILabel *about2 = [[UILabel alloc]init];
    about2.bounds = CGRectMake(0, 0, self.view.bounds.size.width,40);
    about2.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 20);
    about2.text = @"-感谢 开眼App 对本测试的支持-";
    about2.textColor = [UIColor whiteColor];
    about2.backgroundColor=[UIColor clearColor];
    about2.textAlignment = NSTextAlignmentCenter;
    about2.font = [UIFont fontWithName:@"Copperplate" size:15];
    [self.view addSubview:about2];
    
    
}

//背景图滚动
- (void)imageRoll{
    if (_scrollView.contentOffset.x < 1520) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + 1.5, 0) animated:NO];
    }else{
        [_timer invalidate];
    }
    
}

//点击展开登录界面
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_userNameTextField resignFirstResponder];
    [_passWordTextField resignFirstResponder];//回收键盘
    //展开
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _logoImage.center = CGPointMake(self.view.bounds.size.width / 2, 140);
        _nameLabel.center = CGPointMake(self.view.bounds.size.width / 2, 450);
        [_visualEffectView setFrame:CGRectMake(0, 200, self.view.bounds.size.width, 240)];
        _visualEffectView.alpha = 1;
        _registerID.alpha = 0;
    } completion:nil];
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _userNameTextField.alpha = 1;
        _passWordTextField.alpha = 1;
        _loginButton.alpha = 1.0;
        _getRegister.alpha = 1.0;
        
    } completion:nil];
    
}

#pragma mark - 登录相关

-(void)PresentViewController:(HyLoglnButton *)button{
    [_userNameTextField resignFirstResponder];
    [_passWordTextField resignFirstResponder];//回收键盘
    
    typeof(self) __weak weak = self;
    //让进度条转一会儿
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weak LoginButton:button];
    });
}

-(void)LoginButton:(HyLoglnButton *)button
{
    typeof(self) __weak weak = self;
    //网络判定
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    //有网的话响应服务器数据
    if ([reach currentReachabilityStatus]) {
        //响应服务器数据
        [AVUser logInWithUsernameInBackground:_userNameTextField.text password:_passWordTextField.text block:^(AVUser *user, NSError *error) {
            if (user != nil) {
                [button ExitAnimationCompletion:^{
                    [weak didPresentControllerButtonTouch];
                }];
            } else{
                [button ErrorRevertAnimationCompletion:nil];
            }
        
        }];
    }else{
        //没网弹出提示框
        [self noInternet];
    }

}

- (void)didPresentControllerButtonTouch
{
    //网络验证通过后跳转
    
    ShowViewController *showVC = [[ShowViewController alloc]init];
    LeftViewController *leftVC = [[LeftViewController alloc]init];
    HomeViewController *homeVC = [[HomeViewController alloc]initWithShowVC:showVC  leftVC:leftVC];
    
    homeVC.transitioningDelegate = self;
    UINavigationController *nai = [[UINavigationController alloc] initWithRootViewController:homeVC];
    nai.transitioningDelegate = self;
    [_scrollView removeFromSuperview];
    [self presentViewController:nai animated:YES completion:nil];
}

//跳转动画-from third
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.5f isBOOL:true];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.8f isBOOL:false];
}

#pragma mark - 注册
//注册按钮响应
- (void)getRegister:(UIButton *)sender
{
    //展开注册界面
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _loginButton.alpha = 0;
        _getRegister.alpha = 0;
        [_registerID setTitle:@"use the key" forState:UIControlStateNormal];
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [_visualEffectView setFrame:CGRectMake(0, 200, self.view.bounds.size.width, 190)];
        _nameLabel.center = CGPointMake(self.view.bounds.size.width / 2, 400);
        
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _visualEffectView.alpha = 1;
        _userNameTextField.alpha = 1;
        _passWordTextField.alpha = 1;
        _registerID.alpha = 1;
    } completion:nil];
    
}

//注册账号
- (void)registerID:(UIButton *)sender{
    //网络请求
    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    user.username = _userNameTextField.text;// 设置用户名
    user.password =  _passWordTextField.text;// 设置密码
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self registerSucess];//注册成功
        } else {
            [self registerFail];//注册失败
        }
    }];
}
//注册成功
- (void)registerSucess
{
    //注册成功
    [_userNameTextField resignFirstResponder];
    [_passWordTextField resignFirstResponder];//回收键盘
    //展开登录界面
    [UIView animateWithDuration:0.3 delay:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _logoImage.center = CGPointMake(self.view.bounds.size.width / 2, 140);
        _nameLabel.center = CGPointMake(self.view.bounds.size.width / 2, 450);
        [_visualEffectView setFrame:CGRectMake(0, 200, self.view.bounds.size.width, 240)];
        _visualEffectView.alpha = 1;
        _registerID.alpha = 0;
    } completion:nil];
    [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _userNameTextField.alpha = 1;
        _passWordTextField.alpha = 1;
        _loginButton.alpha = 1.0;
        _getRegister.alpha = 1.0;
    } completion:nil];
}

//注册失败
- (void)registerFail
{
    //抖动
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint point = _registerID.layer.position;
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        [NSValue valueWithCGPoint:point]];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyFrame.duration = 0.5;
    keyFrame.delegate = self;
    _registerID.layer.position = point;
    [_registerID.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
    
    [_registerID setTitle:@"use other key" forState:UIControlStateNormal];
    _userNameTextField.text = nil;
    _passWordTextField.text = nil;
}

#pragma mark - 网络状态判定及相关提示
- (void)noInternet{
    [HHAlertView showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"error" detail:@"NO Internet,NO App for you" cancelButton:nil Okbutton:@"OK"];
}


@end
