//
//  HomeViewController.h
//  KeyEye
//
//  Created by 蒋一博 on 16/4/1.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowViewController;
@class  LeftViewController;

@interface HomeViewController : UIViewController

- (id)initWithShowVC:(ShowViewController *)showVC leftVC:(LeftViewController *)leftVC;

@end
