//
//  HyLoglnButton.h
//  KeyEyes
//
//  Created by 蒋一博 on 16/3/19.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinerLayer.h"

typedef void(^Completion)();

@interface HyLoglnButton : UIButton

@property (nonatomic,retain) SpinerLayer *spiner;

-(void)setCompletion:(Completion)completion;

-(void)StartAnimation;

-(void)ErrorRevertAnimationCompletion:(Completion)completion;

-(void)ExitAnimationCompletion:(Completion)completion;

@end
