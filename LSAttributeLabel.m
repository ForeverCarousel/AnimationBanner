//
//  LSAttributeLabel.m
//  BannerDemo
//
//  Created by Carouesl on 2016/12/28.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import "LSAttributeLabel.h"

@interface LSAttributeLabel ()

@property (strong, nonatomic) NSAttributedString* attchmentText;

@end

@implementation LSAttributeLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isVIP = NO;
        self.backgroundColor = [UIColor orangeColor];
        self.baselineAdjustment =  UIBaselineAdjustmentAlignCenters;
    }
    return self;
}



-(void)setText:(NSString *)text
{
    CGSize  oriSize = self.frame.size;
    if (_isVIP) {
        NSMutableAttributedString* attributText = [[NSMutableAttributedString alloc] initWithString:text];

        [attributText insertAttributedString:self.attchmentText atIndex:0];
        //暂时没找到更好的方法 暂时这样
        NSAttributedString* blankString = [[NSAttributedString alloc] initWithString:@" "];
        [attributText insertAttributedString:blankString atIndex:1];

        
        [attributText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributText.length)];

        CGSize currentSize =  [attributText boundingRectWithSize:CGSizeMake(oriSize.width, 0)
                                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading

                                                         context:nil].size;
        self.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y, oriSize.width, currentSize.height);
        
        self.attributedText = attributText;
    }else{
        CGSize currentSize =[text boundingRectWithSize:CGSizeMake(self.bounds.size.width, 0)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:self.font}
                                               context:nil].size;
        self.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y,oriSize.width , currentSize.height);

        [super setText:text];
    }

}
-(NSAttributedString *)attchmentText
{
    if (!_attchmentText) {
        LSLableTextAttachment* attchment = [[LSLableTextAttachment alloc] init];
        //定义图片内容及位置和大小
        attchment.image = [UIImage imageNamed:@"lslabele_vip_icon"];
//        attchment.bounds = CGRectMake(0 ,-1, 20, 12);
       _attchmentText = [NSAttributedString attributedStringWithAttachment:attchment];
        
    }
    return _attchmentText;
}


@end




@implementation LSLableTextAttachment

-(CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer
                     proposedLineFragment:(CGRect)lineFrag
                            glyphPosition:(CGPoint)position
                           characterIndex:(NSUInteger)charIndex
{
    CGRect bounds;
    bounds.origin = CGPointMake(0,0);
    bounds.size = CGSizeMake(self.image.size.width, self.image.size.height);
    return bounds;
}

@end
















