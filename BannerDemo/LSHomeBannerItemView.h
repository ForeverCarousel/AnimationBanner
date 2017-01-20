//
//  LSHomeBannerItemView.h
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSHomeBannerItemView;

@protocol LSHomeBannerItemViewAnimationDelegate <NSObject>

-(void)animationWillStart:(CAAnimation *)anim target:(LSHomeBannerItemView*) targetView;

-(void)animationDidStart:(CAAnimation *)anim target:(LSHomeBannerItemView*) targetView;

-(void)animationDidStop:(CAAnimation *)anim target:(LSHomeBannerItemView*) targetView finished:(BOOL)flag;

@end


typedef NS_ENUM(NSUInteger, LSHomeItemAnimationType) {
    LSHomeItemAnimationTypeLeft,
    LSHomeItemAnimationTypeRight,
    LSHomeItemAnimationTypeDefault,
};


@interface LSHomeBannerItemView : UIView

@property (nonatomic, weak) id <LSHomeBannerItemViewAnimationDelegate> delegate;

-(void)startAnimationWithType:(LSHomeItemAnimationType) type;
-(void)configWithData:(id) data;
-(void)resetData;



@end
