//
//  LSHomeBannerAnimation.m
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import "LSHomeBannerAnimation.h"
#import "LSWeakProxy.h"

#define LSHOME_BANNER_ANIMATION_DURATION  1.0f


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


- (CAAnimationGroup* )leftAnimation
{
    if (!_leftAnimation) {
        __weak typeof (self) weakSelf = self;
        
        //路径
        UIBezierPath* bezierPath = [[UIBezierPath alloc] init];
        [bezierPath moveToPoint:self.layer.position];//160 200
//        [bezierPath addLineToPoint:CGPointMake(-self.layer.position.x, self.layer.position.y)];
//        [bezierPath addCurveToPoint:CGPointMake(-self.layer.position.x*2, self.layer.position.y) controlPoint1:CGPointMake(0, 120) controlPoint2:CGPointMake(0, 120)];
        [bezierPath addQuadCurveToPoint:CGPointMake(-160, 200)  controlPoint:CGPointMake(0, 120)];
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
