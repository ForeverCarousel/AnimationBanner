//
//  LSHomeBannerItemView.m
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import "LSHomeBannerItemView.h"
#import "LSHomeBannerAnimation.h"

#define LSDeallocLog(obj)  NSLog(@"[_%@_] is Dealloced----MemeoryLog",NSStringFromClass([obj class]));

@interface LSHomeBannerItemView()<LSHomeBannerAnimationDelegate>

@property (strong, nonatomic) UIImageView* contentImage;

@property (strong, nonatomic) UIView* tipView;

@property (strong, nonatomic) UILabel* titleLabel;

@property (strong, nonatomic) LSHomeBannerAnimation* animation;

@end

@implementation LSHomeBannerItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        self.animation = [[LSHomeBannerAnimation alloc] initWithDelegate:self];

        self.contentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        self.contentImage.layer.masksToBounds = YES;
        self.contentImage.layer.cornerRadius = 5.0f;
        self.contentImage.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentImage.layer.shadowRadius = 5.0f;
        self.contentImage.layer.shadowOpacity = 0.6;
        self.contentImage.layer.shadowOffset = CGSizeMake(5, 5);
        self.contentImage.backgroundColor = [UIColor greenColor];
        [self addSubview:_contentImage];
        
    }
    return self;
}
-(void)configWithData:(id) data
{
    NSString* imageURL = data;
    self.contentImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
}


-(void)resetData
{
    self.contentImage.image = nil;
}

-(void)startAnimationWithType:(LSHomeItemAnimationType) type
{
    //给下张展示的图预留时间
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationWillStart:target:)])
    {
        [self.delegate animationWillStart:nil target:self];
    }
    
    switch (type) {
        case LSHomeItemAnimationTypeLeft:
            [self.layer addAnimation:self.animation.leftAnimation forKey:nil];
            break;
        case LSHomeItemAnimationTypeRight:
            [self.layer addAnimation:self.animation.rightAnimation forKey:nil];
            break;
        default:
            break;
    }
}
-(void)animationDidStart:(CAAnimation *)anim
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidStart:target:)]    ) {
        [self.delegate animationDidStart:anim target:self];
    }
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.layer removeAllAnimations];
    [self resetData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidStop:target:finished:)]    ) {
        [self.delegate animationDidStop:anim target:self finished:flag];
    }

    
}
-(void)drawRect:(CGRect)rect
{
    
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
