//
//  CarouselFoldView.m
//  BannerDemo
//
//  Created by Carouesl on 2017/1/16.
//  Copyright © 2017年 Chenxiaolong. All rights reserved.
//

#import "CarouselFoldView.h"




@interface CarouselFoldView ()

@property (strong, nonatomic) UIView* gestureView;
@property (strong, nonatomic) CALayer* upLayer;
@property (strong, nonatomic) CALayer* downLayer;

@end

@implementation CarouselFoldView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sensitivity = 1.0f;
        CGSize size = frame.size;
        
        self.upLayer = [[CALayer alloc] init];
        _upLayer.frame = CGRectMake(0, size.height/4, size.width, size.height/2);
        _upLayer.contentsRect = CGRectMake(0, 0, 1, 0.5);
        _upLayer.anchorPoint = CGPointMake(0.5, 1);
        _upLayer.backgroundColor = [UIColor purpleColor].CGColor;
        //是否显示背面 default = YES；
//        _upLayer.doubleSided = NO;
        
        self.downLayer = [[CALayer alloc] init];
        _downLayer.frame = CGRectMake(0, size.height/2, size.width, size.height/2);
        _downLayer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
        _downLayer.backgroundColor = [UIColor orangeColor].CGColor;
        [self.layer addSublayer:_downLayer];
        
        [self.layer addSublayer:_upLayer];

        
        UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
        [self addGestureRecognizer:pgr];
        
    }
    return self;
}


- (void)setImage:(UIImage *)image
{
    _image = image;
    self.upLayer.contents = (id)_image.CGImage;
    self.downLayer.contents = (id)_image.CGImage;
}

-(void)setSensitivity:(CGFloat )sensitivity
{
    _sensitivity = sensitivity;
}



- (void)gestureAction:(UIPanGestureRecognizer* )sender
{
    // 获取手指偏移量
    CGPoint transP = [sender translationInView:self];
//    //如果是在下半部分不响应
//    if (transP.y >= self.bounds.size.height/2) {
//        return;
//    }
    
    // 初始化形变
    CATransform3D transform3D = CATransform3DIdentity;
    // 设置M34就有立体感(近大远小)。 -1 / z ,z表示观察者在z轴上的值,z越小，看起来离我们越近，东西越大。
    transform3D.m34 = -1 / 1000.0;
    // 计算折叠角度，因为需要逆时针旋转，所以取反
    CGFloat angle = -transP.y*_sensitivity / _image.size.height * M_PI;
    _upLayer.transform = CATransform3DRotate(transform3D, angle, 1, 0, 0);
    
    if (sender.state == UIGestureRecognizerStateEnded) { // 手指抬起
        // 还原
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.1
              initialSpringVelocity:3
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _upLayer.transform = CATransform3DIdentity;
                         } completion:nil];
    }
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
