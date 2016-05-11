//
//  SpinerLayer.h
//  KeyEyes
//
//  Created by 蒋一博 on 16/3/19.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SpinerLayer : CAShapeLayer

-(instancetype) initWithFrame:(CGRect)frame;

-(void)animation;

-(void)stopAnimation;

@end
