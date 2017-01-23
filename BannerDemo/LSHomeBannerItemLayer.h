//
//  LSHomeBannerItemView.h
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSHomeBannerItemLayer;

@protocol LSHomeBannerItemLayerAnimationDelegate <NSObject>

-(void)animationWillStart:(CAAnimation *)anim target:(LSHomeBannerItemLayer*) targetView;

-(void)animationDidStart:(CAAnimation *)anim target:(LSHomeBannerItemLayer*) targetView;

-(void)animationDidStop:(CAAnimation *)anim target:(LSHomeBannerItemLayer*) targetView finished:(BOOL)flag;

@end


typedef NS_ENUM(NSUInteger, LSHomeItemAnimationType) {
    LSHomeItemAnimationTypeLeft,
    LSHomeItemAnimationTypeRight,
    LSHomeItemAnimationTypeScale,
    LSHomeItemAnimationTypeDefault,
};


@interface LSHomeBannerItemLayer : CALayer

@property (nonatomic, weak) id <LSHomeBannerItemLayerAnimationDelegate> customDelegate;

-(void)startAnimationWithType:(LSHomeItemAnimationType) type;
-(void)configWithData:(id) data;
-(void)resetData;



@end
