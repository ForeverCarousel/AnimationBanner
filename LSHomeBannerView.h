//
//  LSHomeBannerView.h
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^selectBlock)(id info);

@interface LSHomeBannerView : UIView

- (instancetype)initWithFrame:(CGRect)frame selectBlock:(selectBlock) selBlock;
-(void)configWithData:(id)data;
@end
