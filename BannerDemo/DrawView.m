//
//  DrawView.m
//  BannerDemo
//
//  Created by Carouesl on 2017/2/7.
//  Copyright © 2017年 Chenxiaolong. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIColor* aColor = [UIColor redColor];
//    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
//    CGContextSetStrokeColorWithColor(context, aColor.CGColor);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddArc(context, 0, 0, 100,  0, 90 * M_PI / 180, 0);
//    CGContextClosePath(context);
//    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
//    
//   
//}

//-(void)drawRect:(CGRect)rect
//{
//    CGRect drawRect = CGRectZero;
//    drawRect.origin.x = rect.origin.x +10 ;
//    drawRect.origin.y = rect.origin.y +10;
//    drawRect.size.width = rect.size.width -20 ;
//    drawRect.size.height = rect.size.height -20;
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [[UIColor redColor] set];
//    CGContextSetLineJoin(context, kCGLineJoinRound);
//    CGContextSetLineWidth(context, 4.0f);
//    CGContextAddRect(context, drawRect);
//    CGContextStrokePath(context);
//    
//    CGContextMoveToPoint(context, 50,0);
//    CGContextAddLineToPoint(context, 46, 4);
//    CGContextAddLineToPoint(context, 54, 4);
//    
//    CGContextClosePath(context);
//    [[UIColor redColor] setStroke];
//    [[UIColor redColor] setFill];
//    CGContextDrawPath(context, kCGPathFillStroke);
//}

-(void)drawRect:(CGRect)rect
{
    UIColor* color =[UIColor redColor];
    CGRect drawRect = CGRectZero;
    drawRect.origin.x = rect.origin.x +2  ;
    drawRect.origin.y = rect.origin.y + 8;
    drawRect.size.width = rect.size.width - 4 ;
    drawRect.size.height = rect.size.height -2*8 -4;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color set];
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 2.0f);
    CGContextAddRect(context, drawRect);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, drawRect.size.width/2,4);
    CGContextAddLineToPoint(context, drawRect.size.width/2 - 4, 8);
    CGContextAddLineToPoint(context, drawRect.size.width/2 + 4, 8);
    
    CGContextClosePath(context);
    [color setStroke];
    [color setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
























