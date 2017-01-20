//
//  LSHomeBannerAnimation.m
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import "LSHomeBannerAnimation.h"
#import "LSWeakProxy.h"

#define LSHOME_BANNER_ANIMATION_DURATION  0.5f
#define LSDeallocLog(obj)  NSLog(@"[_%@_] is Dealloced----MemeoryLog",NSStringFromClass([obj class]));


@interface LSHomeBannerAnimation() <CAAnimationDelegate>

@property (weak, nonatomic) CALayer* layer;

@end

@implementation LSHomeBannerAnimation

-(instancetype)initWithDelegate:(id<LSHomeBannerAnimationDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (CAAnimation* )leftAnimation
{
    if (!_leftAnimation) {
        
        
        CGPoint position = CGPointMake(187.5, 150);
        __weak typeof (self) weakSelf = self;
        
        //实例飞行路径
        UIBezierPath* bezierPath = [[UIBezierPath alloc] init];
        [bezierPath moveToPoint:position];
        [bezierPath addLineToPoint:CGPointMake(position.x - 600, position.y)];
        //实例位移动画
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position";
        animation.path = bezierPath.CGPath;
        
        
        //自转
        CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.repeatCount = 1;
        rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];//起始角度
        rotateAnimation.toValue = [NSNumber numberWithFloat: -0.1 * M_PI];//终止角度r
        rotateAnimation.duration = LSHOME_BANNER_ANIMATION_DURATION;
        
        
        //合成动画
        CAAnimationGroup* animationGroup = [CAAnimationGroup animation];
        animationGroup.delegate = weakSelf;
        animationGroup.autoreverses = NO;//是否重播，原动画的倒播
        animationGroup.repeatCount = 1;//HUGE_VALF INT32_MAX NSNotFound
        [animationGroup setAnimations:[NSArray arrayWithObjects: rotateAnimation,animation, nil]];
        //执行完动画是否删除动画
        animationGroup.removedOnCompletion = NO;
        //设置动画保存当前状态
        animationGroup.fillMode = kCAFillModeForwards;
        //设置动画组的时间
        animationGroup.duration = LSHOME_BANNER_ANIMATION_DURATION;
    
        _leftAnimation = animationGroup;
    }
    return _leftAnimation;
}



- (CAAnimationGroup*)rightAnimation
{
    if (!_rightAnimation) {
        
        __weak typeof (self) weakSelf = self;
        
        //路径
        CGPoint position = CGPointMake(187.5, 150);
        UIBezierPath* bezierPath = [[UIBezierPath alloc] init];
        [bezierPath moveToPoint:position];
        [bezierPath addLineToPoint:CGPointMake(position.x + 200, position.y)];
        //位移动画（结束点）
        [bezierPath addLineToPoint:CGPointMake(position.x - 600,position.y)];
        CAKeyframeAnimation* positionAnimation = [CAKeyframeAnimation animation];
        positionAnimation.keyPath = @"position";
        positionAnimation.path = bezierPath.CGPath;
        
        //自转
        CABasicAnimation* fragmentAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        fragmentAnimation.repeatCount = 1;
        fragmentAnimation.fromValue = [NSNumber numberWithFloat:0.0];//起始角度
        fragmentAnimation.toValue = [NSNumber numberWithFloat: -0.1 * M_PI];//终止角度r
        fragmentAnimation.duration = 0.5;
        
        //动画组
        CAAnimationGroup* animationGroup = [CAAnimationGroup animation];
        animationGroup.delegate = weakSelf;
        animationGroup.autoreverses = NO;//是否重播，原动画的倒播
        animationGroup.repeatCount = 1;//HUGE_VALF INT32_MAX NSNotFound
        [animationGroup setAnimations:[NSArray arrayWithObjects:fragmentAnimation, positionAnimation, nil]];
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.duration = 0.5f;
        _rightAnimation = animationGroup;
    }
    
    return _rightAnimation;
}

-(void)animationDidStart:(CAAnimation *)anim
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidStart:)]) {
        [self.delegate animationDidStart:anim];
        
    }
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidStop:finished:)]) {
        [self.delegate animationDidStop:anim finished:flag];
        
    }
    
    
}

-(void)dealloc
{
    LSDeallocLog(self);
}

@end
