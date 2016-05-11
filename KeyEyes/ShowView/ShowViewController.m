//
//  ShowViewController.m
//  KeyEyes
//
//  Created by 蒋一博 on 16/3/19.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "ShowViewController.h"
#import "ShowTableViewCell.h"
#import "ShowPhotoView.h"
#import "UIImageView+WebCache.h"
#import "MyPlayerViewController.h"



@interface ShowViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray   *dataSource;
}

//自定义导航栏属性
@property (nonatomic,strong) UIImageView * imageView;
@property  (nonatomic,strong) UIView *view_bar;

//Table
@property (nonatomic,strong) UITableView *showTable;

//展示照片的view
@property (nonatomic,strong) ShowPhotoView *showPhoto;
//行数标题日期相关
@property (nonatomic, retain) NSMutableArray *dateArray;


@end

@implementation ShowViewController

//保证竖屏显示
- (void)viewWillAppear:(BOOL)animated{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //UITableView
    _showTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _showTable.translatesAutoresizingMaskIntoConstraints = NO;
    _showTable.showsHorizontalScrollIndicator = NO;
    _showTable.showsVerticalScrollIndicator = NO;
    _showTable.frame = self.view.bounds;
    _showTable.rowHeight = 200;
    _showTable.delegate = self;
    _showTable.dataSource = self;
    
    [self initializeDataSource];
    [self initializeInterface];

}

#pragma mark - 加载
- (void)initializeDataSource
{
    _dateArray = [[NSMutableArray alloc]init];
    //数据源加载
    
    //Get请求
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *urlString = [NSString stringWithFormat:KEY_EYE,dateString];
    //创建url
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *requst = [NSURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //数据解析
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        dataSource = [object[@"dailyList"] mutableCopy];
        //NSLog(@"%@",dataSource);
        //刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [_showTable reloadData];
        });
    }];
    //开始请求
    [task resume];
}

- (void)initializeInterface
{
    [self.view addSubview:_showTable];
}



#pragma mark - UITableViewDelegate,UITableViewDataSource
//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count;
}
//设置每组的cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"mycell";
    ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[ShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    //图片加载
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:dataSource[indexPath.section][@"videoList"][indexPath.row][@"coverForDetail"]]];
    
    //标题加载
    cell.titleLabel.text = dataSource[indexPath.section][@"videoList"][indexPath.row][@"title"];
    CGFloat yOffset = ((_showTable.contentOffset.y - cell.frame.origin.y) / 200) * 45;
    cell.imageOffset = CGPointMake(-37.5, yOffset);
    
    if (indexPath.section > 1) {
        //出现动画
        CATransform3D rotation;//3D旋转
        rotation = CATransform3DMakeTranslation(0 ,50 ,20);
        rotation = CATransform3DScale(rotation, 0.8, 0.8, 1);
        rotation.m34 = 1.0/ - 600;
        cell.layer.transform = rotation;
        [UIView beginAnimations:@"rotation" context:NULL];
        [UIView setAnimationDuration:0.6];
        cell.layer.transform = CATransform3DIdentity;
        [UIView commitAnimations];
        [cell cellOffset];

    }
    return cell;
}
//行高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

//设置行标题－为相应日期
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 375.0, 30.0)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:customView.frame];
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithRed:0.21 green:0.60 blue:0.93 alpha:1.00];
    headerLabel.font = [UIFont fontWithName:@"Copperplate" size:15];
    
    //设置日期内容
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSDate *theDayBefor = [date dateByAddingTimeInterval: - 60*60*24 *section];
    NSString *dateString = [dateFormatter stringFromDate:theDayBefor];
    NSString *headString = [NSString stringWithFormat:@"● %@   ",dateString];
    
    headerLabel.text = headString;
    [customView addSubview:headerLabel];
    
    return customView;
}


#pragma mark - next

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //视差变化
    for(ShowTableViewCell *view in _showTable.visibleCells) {
        CGFloat yOffset = ((_showTable.contentOffset.y - view.frame.origin.y) / 200) * 45;
        view.imageOffset = CGPointMake(-37.5, yOffset);
    }
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ShowTableViewCell *cell = [_showTable cellForRowAtIndexPath:indexPath];
    CGRect rect = [cell convertRect:cell.bounds toView:nil];
    CGFloat y = rect.origin.y;
    
    _showPhoto = [[ShowPhotoView alloc]initWithFrame:CGRectMake(0, 0, 375, 667) offsetY:y];
    
    
    //图片加载
    [_showPhoto.showImageView sd_setImageWithURL:[NSURL URLWithString:dataSource[indexPath.section][@"videoList"][indexPath.row][@"coverForDetail"]]];
    _showPhoto.imageUrl = dataSource[indexPath.section][@"videoList"][indexPath.row][@"coverForDetail"];
    //标题加载
    _showPhoto.theImageName = dataSource[indexPath.section][@"videoList"][indexPath.row][@"title"];
    //内容文本加载
    _showPhoto.aboutImage = dataSource[indexPath.section][@"videoList"][indexPath.row][@"description"];
    
    _showPhoto.playerUrl = dataSource[indexPath.section][@"videoList"][indexPath.row][@"playUrl"];
    [self.view addSubview:_showPhoto];
    
    [_showPhoto photoAnimation];
    
    //block点击事件
    [_showPhoto playerWithURL:^(NSString *URL) {
        
        MyPlayerViewController *player = [[MyPlayerViewController alloc]init];
        player.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        player.playerUrl = URL;
        
        [self presentViewController:player animated:YES completion:nil];

    }];
    
    //轻扫手势
    UISwipeGestureRecognizer *Swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [_showPhoto addGestureRecognizer:Swipe];
    
}

- (void)panAction:(UISwipeGestureRecognizer *)swipe
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _showPhoto.center = CGPointMake(700, 667/2);
        _showPhoto.alpha = 0;
    } completion:^(BOOL finished) {
        [_showPhoto removeFromSuperview];
    }];
}




@end
