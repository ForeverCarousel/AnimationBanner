//
//  LSHomeBannerAnimation.h
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol LSHomeBannerAnimationDelegate <NSObject>

-(void)animationDidStart:(CAAnimation *)anim;

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end

@interface LSHomeBannerAnimation : NSObject


- (instancetype)initWithDelegate:(id<LSHomeBannerAnimationDelegate>) delegate;

@property (weak, nonatomic) id<LSHomeBannerAnimationDelegate>  delegate;

@property (strong, nonatomic) CAAnimationGroup* leftAnimation;
@property (strong, nonatomic) CAAnimationGroup* rightAnimation;

@end
