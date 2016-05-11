//
//  LeftViewController.m
//  KeyEye
//
//  Created by 蒋一博 on 16/4/1.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "LeftViewController.h"
#import "UIImageView+WebCache.h"
#import "MyPlayerViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isChange;
    BOOL _isH;
}
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;
@property (strong, nonatomic) UIImageView *colorBack;
@property (strong, nonatomic) UIImageView *headerView;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UIButton *exitButton;
@property (strong, nonatomic) UIImageView *likeLogo;

@property (strong, nonatomic) NSArray *getArr;
@property (strong, nonatomic) UITableView *likeTable;
@property (strong, nonatomic) UILabel *underTip;
@property (strong, nonatomic) UILabel *tipLabel;


@property (strong, nonatomic) UIImageView *textView;
@property (strong, nonatomic) UILabel *onImage;
@property (strong, nonatomic) UILabel *imageName;
@property (strong, nonatomic) UILabel *cutLine;
@property (strong, nonatomic) UILabel *aboutImage;
@property (strong, nonatomic) UIButton *playButton;

@property (strong, nonatomic) NSString *likeUrl;




@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //backgroudImage
    _colorBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 270, 667)];
    [_colorBack setImage:[UIImage imageNamed:@"colorback-b.jpg"]];
    _colorBack.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_colorBack];
    
    //模糊遮罩
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    _visualEffectView.alpha = 0.6;
    [_visualEffectView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 667)];
    [self.view addSubview:_visualEffectView];
    
    //头像
    _headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"头像"]];
    _headerView.bounds = CGRectMake(0, 0, 80, 80);
    _headerView.center = CGPointMake(270/2, 130);
    //圆角
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius = 40;
    //边框
    _headerView.layer.borderColor = [UIColor clearColor].CGColor;//颜色
    _headerView.layer.borderWidth = 3;//宽度

    [self.view addSubview:_headerView];
    
    //用户名
    _userName = [[UILabel alloc]init];
    _userName.bounds = CGRectMake(0, 0, 200, 40);
    _userName.center = CGPointMake(270/2, 200);
    _userName.text = @"dawninest";//暂时用
    _userName.textColor = [UIColor whiteColor];
    _userName.backgroundColor=[UIColor clearColor];
    _userName.textAlignment = NSTextAlignmentCenter;
    _userName.font = [UIFont fontWithName:@"Copperplate" size:20];
    
    [self.view addSubview:_userName];
    
    //注销当前用户按钮
    _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _exitButton.bounds = CGRectMake(0, 0, 200, 30);
    _exitButton.center = CGPointMake(270/2, 630);
    _exitButton.titleLabel.font = [UIFont fontWithName:@"Copperplate" size:15];
    _exitButton.backgroundColor = [UIColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.00];
    _exitButton.layer.cornerRadius = 10;
    _exitButton.clipsToBounds = YES;
    [_exitButton setTitle:@"user other eye" forState:UIControlStateNormal];
    [_exitButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_exitButton addTarget:self action:@selector(exitButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_exitButton];
    
    //LikeLogo
    _likeLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"likeR"]];
    _likeLogo.bounds = CGRectMake(0, 0, 80, 80);
    _likeLogo.center = CGPointMake(270/2, 240);
    _likeLogo.alpha = 0.8;
    _likeLogo.backgroundColor = [UIColor clearColor];
    _likeLogo.userInteractionEnabled = YES;
    [self.view addSubview:_likeLogo];
    //添加likelogo手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeLogo:)];
    [_likeLogo addGestureRecognizer:tapGes];
    
    //name,介绍,视频链接
    _getArr = [[AVUser currentUser] objectForKey:@"like"];
    
#pragma mark - 喜欢列表
    //外框
    UILabel *tableBox = [[UILabel alloc]init];
    tableBox.frame = CGRectMake(-10, 260, 290, 500);
    tableBox.backgroundColor = [UIColor clearColor];
    tableBox.layer.cornerRadius = 10;
    tableBox.clipsToBounds = YES;
    [tableBox.layer setBorderWidth:2.0];
    [tableBox.layer setBorderColor:[UIColor colorWithRed:0.95 green:0.00 blue:0.22 alpha:1.00].CGColor];
    [self.view addSubview:tableBox];
    
    _likeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 260, 270, 350) style:UITableViewStylePlain];
    _likeTable.rowHeight = 50;
    _likeTable.backgroundColor = [UIColor clearColor];
    _likeTable.showsHorizontalScrollIndicator = NO;
    _likeTable.showsVerticalScrollIndicator = NO;
    _likeTable.separatorStyle = NO;
    _likeTable.delegate = self;
    _likeTable.dataSource = self;
    
    [self.view addSubview:_likeTable];
    
    
    
    
}

- (void)exitButtonTaped:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//补救手段之点击like刷新
- (void)likeLogo:(UIButton *)sender {
    NSLog(@"❤️");
    _getArr = [[AVUser currentUser] objectForKey:@"like"];
    [_likeTable reloadData];
    _likeTable.userInteractionEnabled = YES;
    _likeUrl = @"";
    //消除动画
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _textView.alpha = 0;
        _onImage.alpha = 0;
        _imageName.alpha = 0;
        _cutLine.alpha = 0;
        _aboutImage.alpha = 0;
        _playButton.alpha = 0;
    } completion:^(BOOL finished) {
        [_underTip removeFromSuperview];
    }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _getArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //table view的重用机制
    //1.声明一个可重用标识符
    static NSString *cellIdentifer = @"mycell";
    //2.从队列中拿出一个可重用的特殊cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        //3.如果cell没有被初始化，则初始化它
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.text = _getArr[indexPath.row][0];
    return cell;

}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消cell选中的颜色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _likeUrl = _getArr[indexPath.row][3];
    
    _likeTable.userInteractionEnabled = NO;
    //弹出跳转框，懒得跳大括号传值了，就整里面了
    //全屏遮罩
    _underTip = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 270, 667)];
    _underTip.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_underTip];
        
    _tipLabel = [[UILabel alloc]init];
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.frame = CGRectMake(10, 260, 250, 300);
    [_underTip addSubview:_tipLabel];
        
    //文本载板
    _textView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40,250 , 0)];
    _textView.backgroundColor = [UIColor colorWithRed:0.21 green:0.60 blue:0.93 alpha:1.00];
    [_textView sd_setImageWithURL:[NSURL URLWithString:_getArr[indexPath.row][2]]];
    _textView.contentMode = UIViewContentModeScaleAspectFill;
    _textView.layer.cornerRadius = 20;
    _textView.clipsToBounds = YES;
    [_tipLabel addSubview:_textView];
    
    _onImage = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 250, 0)];
    _onImage.backgroundColor = [UIColor colorWithRed:0.06 green:0.04 blue:0.13 alpha:0.25];
    _onImage.layer.cornerRadius = 20;
    _onImage.clipsToBounds = YES;
    [_tipLabel addSubview:_onImage];
    
        
    //名字
    _imageName = [[UILabel alloc]initWithFrame:CGRectMake(20, 60,210, 40)];
    _imageName.text = _getArr[indexPath.row][0];
    _imageName.textColor = [UIColor whiteColor];
    _imageName.backgroundColor=[UIColor clearColor];
    _imageName.textAlignment = NSTextAlignmentCenter;
    _imageName.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    _imageName.alpha = 0;
    [_tipLabel addSubview:_imageName];
    //分割线
    _cutLine = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 210, 1)];
    _cutLine.backgroundColor = [UIColor whiteColor];
    _cutLine.alpha = 0;
    [_tipLabel addSubview:_cutLine];
    //介绍
    _aboutImage = [[UILabel alloc]initWithFrame:CGRectMake(20, 110, 210, 180)];
    _aboutImage.backgroundColor = [UIColor clearColor];
    _aboutImage.text = _getArr[indexPath.row][1];
    _aboutImage.numberOfLines = 0;
    _aboutImage.textColor = [UIColor whiteColor];
    _aboutImage.backgroundColor=[UIColor clearColor];
    _aboutImage.textAlignment = NSTextAlignmentLeft;
    _aboutImage.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [_aboutImage sizeToFit];
    _aboutImage.alpha = 0;
    [_tipLabel addSubview:_aboutImage];
        
    //播放按钮
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.bounds = CGRectMake(0, 0, 0, 0);
    _playButton.center = CGPointMake(270/2 - 50, 300);
    _playButton.alpha = 0;
    _playButton.backgroundColor = [UIColor clearColor];
    [_playButton setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playLike:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_playButton];

    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:0 animations:^{
        _playButton.alpha = 1;
        _playButton.bounds = CGRectMake(0, 0, 100, 100);
        _playButton.center = CGPointMake(270/2, 300);
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _textView.frame = CGRectMake(0, 40,250 , 280);
        _onImage.frame = CGRectMake(0, 40,250 , 280);
        _imageName.alpha = 1;
        _cutLine.alpha = 1;
        _aboutImage.alpha = 1;
    } completion:nil];

}

- (void)playLike:(UIButton *)sender{
    MyPlayerViewController *player = [[MyPlayerViewController alloc]init];
    player.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    player.playerUrl = _likeUrl;
    [self presentViewController:player animated:YES completion:nil];
}




@end
