//
//  HyTransitions.h
//  KeyEyes
//
//  Created by 蒋一博 on 16/3/19.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HyTransitions : NSObject <UIViewControllerAnimatedTransitioning>

-(instancetype) initWithTransitionDuration:(NSTimeInterval)transitionDuration StartingAlpha:(CGFloat)startingAlpha isBOOL:(BOOL)is;

@end
