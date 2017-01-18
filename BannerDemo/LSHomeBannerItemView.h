//
//  LSHomeBannerItemView.h
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSHomeBannerItemView : UIView

@property (nonatomic, assign) BOOL isWorking;

-(void)configWithData:(id) data;
-(void)resetData;



@end
