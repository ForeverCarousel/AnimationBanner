//
//  LSHomeBannerItemView.m
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import "LSHomeBannerItemView.h"


@interface LSHomeBannerItemView()

@property (strong, nonatomic) UIImageView* contentImage;

@property (strong, nonatomic) UIView* tipView;

@property (strong, nonatomic) UILabel* titleLabel;

@end

@implementation LSHomeBannerItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
