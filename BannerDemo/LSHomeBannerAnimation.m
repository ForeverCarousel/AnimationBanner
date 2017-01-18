//
//  LSHomeBannerAnimation.m
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import "LSHomeBannerAnimation.h"
#import "LSWeakProxy.h"

#define LSHOME_BANNER_ANIMATION_DURATION  3.0f


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
    CABasicAnimation* fragmentAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    fragmentAnimation.repeatCount = 1;
    fragmentAnimation.fromValue = [NSNumber numberWithFloat:0.0];//起始角度
    fragmentAnimation.toValue = [NSNumber numberWithFloat: -0.1 * M_PI];//终止角度r
    fragmentAnimation.duration = LSHOME_BANNER_ANIMATION_DURATION;
    
    
    //合成动画
    CAAnimationGroup* animationGroup = [CAAnimationGroup animation];
    animationGroup.delegate = weakSelf;
    animationGroup.autoreverses = NO;//是否重播，原动画的倒播
    animationGroup.repeatCount = 1;//HUGE_VALF INT32_MAX NSNotFound
    [animationGroup setAnimations:[NSArray arrayWithObjects: fragmentAnimation,animation, nil]];
    //执行完动画是否删除动画
    animationGroup.removedOnCompletion = NO;
    //设置动画保存当前状态
    animationGroup.fillMode = kCAFillModeForwards;
    //设置动画组的时间
    animationGroup.duration = LSHOME_BANNER_ANIMATION_DURATION;
    //将上述两个动画编组
    return animationGroup;
}

- (CAAnimationGroup* )leftAnimation1
{
    if (!_leftAnimation) {
        __weak typeof (self) weakSelf = self;
        //路径
        UIBezierPath* bezierPath = [[UIBezierPath alloc] init];
        [bezierPath moveToPoint:CGPointMake(160, 200)];//160 200
//        [bezierPath addLineToPoint:CGPointMake(-self.layer.position.x, self.layer.position.y)];
//        [bezierPath addCurveToPoint:CGPointMake(-self.layer.position.x*2, self.layer.position.y) controlPoint1:CGPointMake(0, 120) controlPoint2:CGPointMake(0, 120)];
        [bezierPath addQuadCurveToPoint:CGPointMake(-160, 200)  controlPoint:CGPointMake(0, 200)];
        CAKeyframeAnimation* positionAnimation = [CAKeyframeAnimation animation];
        positionAnimation.keyPath = @"position";
        positionAnimation.path = bezierPath.CGPath;

        
        //自转
        CABasicAnimation* fragmentAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        fragmentAnimation.repeatCount = 1;
        fragmentAnimation.fromValue = [NSNumber numberWithFloat:0.0];//起始角度
        fragmentAnimation.toValue = [NSNumber numberWithFloat: -0.1 * M_PI];//终止角度r
        fragmentAnimation.duration = LSHOME_BANNER_ANIMATION_DURATION;
        
        
        //动画组
        CAAnimationGroup*animationGroup = [CAAnimationGroup animation];
        animationGroup.delegate = weakSelf;
        animationGroup.autoreverses = NO;//是否重播，原动画的倒播
        animationGroup.repeatCount = 1;//HUGE_VALF INT32_MAX NSNotFound
        [animationGroup setAnimations:[NSArray arrayWithObjects: fragmentAnimation,positionAnimation, nil]];
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
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
    UIBezierPath* bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointZero];
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
    
}

@end
