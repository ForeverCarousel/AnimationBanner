//
//  LSHomeBannerItemView.m
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import "LSHomeBannerItemLayer.h"
#import "LSHomeBannerAnimation.h"

#define LSDeallocLog(obj)  NSLog(@"[_%@_] is Dealloced----MemeoryLog",NSStringFromClass([obj class]));

@interface LSHomeBannerItemLayer()<LSHomeBannerAnimationDelegate>

@property (strong, nonatomic) CALayer* contentImage;

@property (strong, nonatomic) UIView* tipView;

@property (strong, nonatomic) CATextLayer* titleLayer;

@property (strong, nonatomic) LSHomeBannerAnimation* animation;

@end

@implementation LSHomeBannerItemLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor].CGColor;
        
        self.animation = [[LSHomeBannerAnimation alloc] initWithDelegate:self];
     
        
        //图片
        self.contentImage = [[CALayer alloc] init ];
        self.contentImage.bounds = CGRectMake(0, 0, 300 ,200);
        self.contentImage.position = CGPointMake(150, 100);
        self.contentImage.masksToBounds = YES;
        self.contentImage.cornerRadius = 5.0f;
        self.contentImage.backgroundColor = [UIColor greenColor].CGColor;
        [self addSublayer:_contentImage];
        //浮层阴影
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 300,40);
        gradientLayer.masksToBounds = YES;
        gradientLayer.cornerRadius = 5.0f;
        [gradientLayer setColors:[NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor,(id)[UIColor clearColor].CGColor, nil]];
        [self addSublayer:gradientLayer];
        //标题
        self.titleLayer = [[CATextLayer alloc] init];
        self.titleLayer.contentsScale = [UIScreen mainScreen].scale;
        self.titleLayer.fontSize = 14.0f;
        self.titleLayer.foregroundColor = [UIColor whiteColor].CGColor;
        self.titleLayer.alignmentMode = @"left";
        self.titleLayer.bounds = CGRectMake(0, 0, 200, 30);
        self.titleLayer.position = CGPointMake(110, 15 + 5);
        [self addSublayer:self.titleLayer];
        
    }
    return self;
}
-(void)configWithData:(id) data
{
    NSString* imageURL = [data objectForKey:@"logo"];
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    self.contentImage.contents = (id)image.CGImage;
//    self.contentImage.contents = (id)[UIImage imageNamed:@"faye"].CGImage;
    
    NSString* title = [data objectForKey:@"title"];
    self.titleLayer.string = title;
    
    
//    [self setNeedsDisplay];
}


-(void)resetData
{
    self.contentImage.contents = nil;
    self.titleLayer.string = nil;
}

-(void)startAnimationWithType:(LSHomeItemAnimationType) type
{
    //给下张展示的图预留时间
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(animationWillStart:target:)])
    {
        [self.customDelegate animationWillStart:nil target:self];
    }
    
    switch (type) {
        case LSHomeItemAnimationTypeLeft:
            [self addAnimation:self.animation.leftAnimation forKey:nil];
            break;
        case LSHomeItemAnimationTypeRight:
            [self addAnimation:self.animation.rightAnimation forKey:nil];
            break;
        case LSHomeItemAnimationTypeScale:
            [self addAnimation:self.animation.scaleAnimation forKey:nil];
        default:
            break;
    }
}


#pragma mark - Animation Delegate

-(void)animationDidStart:(CAAnimation *)anim
{
    
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(animationDidStart:target:)]    ) {
        [self.customDelegate animationDidStart:anim target:self];
    }
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeAllAnimations];
    [self resetData];
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(animationDidStop:target:finished:)]    ) {
        [self.customDelegate animationDidStop:anim target:self finished:flag];
    }

    
}
-(void)dealloc
{
    LSDeallocLog(self);
}


/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/

@end
