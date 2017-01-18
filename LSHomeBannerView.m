//
//  LSHomeBannerView.m
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import "LSHomeBannerView.h"
#import "LSHomeBannerItemView.h"
#import "LSWeakProxy.h"

#define LSHBI_CREAT_COUNT_MAX   2

#define LSHBI_AUTO_FLOW_TIME    3.0f

#define LSHBI_ANIMATION_LEFT_KEY   @"111"
#define LSHBI_ANIMATION_RIGHT_KEY  @"222"

@interface LSHomeBannerView()<LSHomeBannerItemViewAnimationDelegate>

@property (strong, nonatomic) NSMutableArray<LSHomeBannerItemView*>* itemViewsArray;
@property (strong, nonatomic) NSMutableArray* dataArray;

@property (strong, nonatomic) UIView* maskGestureView;

@property (strong, nonatomic) UILabel* pageView;

@property (strong, nonatomic) NSTimer* autoFlowTimer;

@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation LSHomeBannerView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        self.itemViewsArray = [NSMutableArray arrayWithCapacity:LSHBI_CREAT_COUNT_MAX];
        self.dataArray = [NSMutableArray array];
        self.currentIndex = 0;
        for (int i = 0; i < LSHBI_CREAT_COUNT_MAX; ++i) {
            LSHomeBannerItemView* itemView = [[LSHomeBannerItemView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
            itemView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
            itemView.delegate = self;
            [self.itemViewsArray addObject:itemView];
        }
        
        //默认添加一张
        [self addSubview:self.itemViewsArray[0]];
        
        [self bringSubviewToFront:self.maskGestureView];
        
    }
    return self;
}


-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview != nil) {

    }else{
        
    }
}

-(void)layoutSubviews{
    
}





#pragma mark - Action

-(void)panGestureAction:(UIPanGestureRecognizer* )pgr
{
    
    
    
}

-(void)autoFlowAction:(NSTimer* )timer
{
    LSHomeBannerItemView* next = [self dequeueReusableItemView];
    [next startAnimationWithType:LSHomeItemAnimationTypeLeft];
}


-(void)startTimer
{
    [[NSRunLoop currentRunLoop] addTimer:self.autoFlowTimer forMode:NSRunLoopCommonModes];
}

-(void)stopTimer
{
    [self.autoFlowTimer invalidate];
    self.autoFlowTimer = nil;
}



#pragma mark - Data Handle

-(void)configWithData:(id)data
{
    [self stopTimer];
    NSMutableArray* bannerArray = [[[data objectForKey:@"data"] firstObject] objectForKey:@"items"];
    
    [bannerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* imageURL = [obj objectForKey:@"logo"];
        [self.dataArray addObject:imageURL];
    }];
    //立即给第一张图赋值
    [self.itemViewsArray[0] configWithData:self.dataArray[0]];
    [self startTimer];
}


-(void)resetViewPosition:(LSHomeBannerItemView*) view
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    view.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    if (view.superview == nil) {
        [self addSubview:view];
    }
    [self sendSubviewToBack:view];
    [CATransaction commit];

}


-(LSHomeBannerItemView* )dequeueReusableItemView
{
    if (self.itemViewsArray.count != 0) {
        for (LSHomeBannerItemView* temp  in self.itemViewsArray) {
            if (temp.state == LSHomeBannerItemViewStateReuseable) {
                return temp;
            }
        }
        return nil;
    }else{
        return nil;
    }

}



#pragma mark - Animation Delegate


-(void)animationDidStart:(CAAnimation *)anim target:(LSHomeBannerItemView *)targetView
{
    //计数增加
    self.currentIndex++;
    if (self.currentIndex > self.dataArray.count - 1) {
        self.currentIndex = 0;//循环
    }
    //动画开始 修改item的状态 置为不可以
    targetView.state = LSHomeBannerItemViewStateUsing;
    //取出一个可用的放到当前显示位置
    LSHomeBannerItemView* nextDisplayView = [self dequeueReusableItemView];
    [nextDisplayView configWithData:self.dataArray[self.currentIndex]];
    [self resetViewPosition:nextDisplayView];
    
    
}


-(void)animationDidStop:(CAAnimation *)anim target:(LSHomeBannerItemView *)targetView finished:(BOOL)flag
{
//    //动画结束 重置状态
    targetView.state = LSHomeBannerItemViewStateReuseable;
    //暂时移除
    [targetView removeFromSuperview];
    //刷新页码
    self.pageView.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex + 1,(unsigned long)self.dataArray.count];
    
}





#pragma mark -  LazyLoad

-(UIView *)maskGestureView
{
    if (!_maskGestureView) {
        _maskGestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300,200)];
        _maskGestureView.backgroundColor = [UIColor clearColor];
        _maskGestureView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_maskGestureView addGestureRecognizer:pgr];
        [self addSubview:_maskGestureView];
        [_maskGestureView addSubview:self.pageView];
        self.pageView.center = CGPointMake(_maskGestureView.bounds.size.width/2, _maskGestureView.bounds.size.height-20/2 -10);
        
        
    }
    return _maskGestureView;
}


-(UIView *)pageView
{
    if (!_pageView) {
        _pageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        _pageView.layer.masksToBounds = YES;
        _pageView.layer.cornerRadius = 10;
        _pageView.textAlignment = NSTextAlignmentCenter;
        _pageView.backgroundColor = [UIColor  colorWithRed:0 green:0 blue:0 alpha:0.6];
        _pageView.textColor = [UIColor whiteColor];
        
    }
    return _pageView;
}

-(NSTimer *)autoFlowTimer
{
    if (!_autoFlowTimer) {
        _autoFlowTimer = [NSTimer timerWithTimeInterval:LSHBI_AUTO_FLOW_TIME
                                                 target:[LSWeakProxy proxyWithTarget:self]
                                               selector:@selector(autoFlowAction:)
                                               userInfo:nil
                                                repeats:YES];
    }
    return _autoFlowTimer;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
