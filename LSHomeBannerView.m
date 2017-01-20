//
//  LSHomeBannerView.m
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import "LSHomeBannerView.h"
#import "LSHomeBannerItemLayer.h"
#import "LSWeakProxy.h"
#define LSDeallocLog(obj)  NSLog(@"[_%@_] is Dealloced----MemeoryLog",NSStringFromClass([obj class]));

#define LSHBI_CREAT_COUNT_MAX   2

#define LSHBI_AUTO_FLOW_TIME    3.0f

#define LSHBI_ANIMATION_LEFT_KEY   @"111"
#define LSHBI_ANIMATION_RIGHT_KEY  @"222"

@interface LSHomeBannerView()<LSHomeBannerItemLayerAnimationDelegate>

@property (strong, nonatomic) NSMutableArray<LSHomeBannerItemLayer*>* reuseArray;
@property (strong, nonatomic) NSMutableArray<LSHomeBannerItemLayer*>* usingArray;

@property (strong, nonatomic) NSMutableArray* dataArray;

@property (strong, nonatomic) UIView* maskGestureView;

@property (strong, nonatomic) UILabel* pageView;

@property (strong, nonatomic) NSTimer* autoFlowTimer;

@property (assign, nonatomic) NSInteger currentIndex;

@property (assign, nonatomic) BOOL gestureEnable;

@property (assign, nonatomic) CGPoint startPoint ,endPoint;

@property (copy, nonatomic) selectBlock block;

@end

@implementation LSHomeBannerView


- (instancetype)initWithFrame:(CGRect)frame selectBlock:(selectBlock) selBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.block = selBlock;
        self.gestureEnable = YES;
        self.backgroundColor = [UIColor grayColor];
        self.reuseArray = [NSMutableArray arrayWithCapacity:LSHBI_CREAT_COUNT_MAX];
        self.usingArray = [NSMutableArray arrayWithCapacity:LSHBI_CREAT_COUNT_MAX];
        self.dataArray = [NSMutableArray array];
        self.currentIndex = 0;
        
        //显示阴影
        CALayer* backLayer = [[CALayer alloc] init];
        backLayer.bounds= CGRectMake(0, 0, 300, 200);
        backLayer.backgroundColor = [UIColor clearColor].CGColor;
        backLayer.position = CGPointMake(frame.size.width/2 , frame.size.height/2);
        backLayer.shadowColor = [UIColor blackColor].CGColor;
        backLayer.shadowRadius = 5.0f;
        backLayer.shadowOpacity = 0.8;
        backLayer.shadowOffset = CGSizeMake(5, 5);
        [self.layer addSublayer:backLayer];
        
        for (int i = 0; i < LSHBI_CREAT_COUNT_MAX; ++i) {
            LSHomeBannerItemLayer* itemView = [[LSHomeBannerItemLayer alloc] init];
            itemView.bounds = CGRectMake(0, 0, 300, 200);
            itemView.position = CGPointMake(frame.size.width/2, frame.size.height/2);
            itemView.customDelegate = self;
            [self.reuseArray addObject:itemView];
        }
        // 由于数组是追加 所以需要切换下位置
        for (int i = LSHBI_CREAT_COUNT_MAX - 1; i >= 0; i--) {
            [self.layer addSublayer:self.reuseArray[i]];
        }
        [self bringSubviewToFront:self.maskGestureView];
        
    }
    return self;
}


-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        [self.autoFlowTimer invalidate];
        self.autoFlowTimer = nil;
    }
}
-(void)layoutSubviews{
    
}





#pragma mark - Action

-(void)panGestureAction:(UIPanGestureRecognizer* )sender
{
    if (!_gestureEnable) {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _startPoint = [sender translationInView:self.maskView];
    }else if (sender.state == UIGestureRecognizerStateEnded){
        _endPoint = [sender translationInView:self.maskView];
        if (_startPoint.x - _endPoint.x > 10) {
            LSHomeBannerItemLayer* next = [self dequeueReusableItemView];
            [next startAnimationWithType:LSHomeItemAnimationTypeLeft];
            [self.autoFlowTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
        }
        if (_startPoint.x - _endPoint.x < 10) {
        
            LSHomeBannerItemLayer* next = [self dequeueReusableItemView];
            [next startAnimationWithType:LSHomeItemAnimationTypeRight];
            [self.autoFlowTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
        }
    }
    
}
-(void)tapGestureAction:(UITapGestureRecognizer* )sender
{
    id info = self.dataArray[_currentIndex];
    if (self.block) {
        self.block(info);
    }
}
-(void)autoFlowAction:(NSTimer* )timer
{
    LSHomeBannerItemLayer* next = [self dequeueReusableItemView];
    [next startAnimationWithType:LSHomeItemAnimationTypeLeft];
//    [next startAnimationWithType:LSHomeItemAnimationTypeRight];

}


-(void)startTimer
{
//    if (![self.autoFlowTimer isValid]) {
//        [[NSRunLoop currentRunLoop] addTimer:self.autoFlowTimer forMode:NSRunLoopCommonModes];
//    }
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
    //重置状态值
    self.currentIndex = 0;
    self.gestureEnable = YES;
    self.pageView.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex + 1,(unsigned long)self.dataArray.count];
    [self stopTimer];
    
    NSMutableArray* bannerArray = [[[data objectForKey:@"data"] firstObject] objectForKey:@"items"];
    self.dataArray = bannerArray;
    //立即给第一张图赋值
    [self.reuseArray[0] configWithData:self.dataArray[0]];
    [self startTimer];
}


-(void)resetViewPosition:(LSHomeBannerItemLayer*) itemLayer
{
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
    itemLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    if (itemLayer.superlayer == nil) {
        [self.layer addSublayer:itemLayer];
    }
//    [self sendSubviewToBack:view];
    [self.layer insertSublayer:itemLayer atIndex:0];
//    [CATransaction commit];

}


-(LSHomeBannerItemLayer* )dequeueReusableItemView
{
    LSHomeBannerItemLayer* reuseItem = [self.reuseArray firstObject];
    return reuseItem? : nil;
}



#pragma mark - Animation Delegate

-(void)animationWillStart:(CAAnimation *)anim target:(LSHomeBannerItemLayer *)targetView
{
    //计数增加
    self.currentIndex++;
    if (self.currentIndex > self.dataArray.count - 1) {
        self.currentIndex = 0;//循环
    }
    //从可复用数组移除 添加到正在使用数组
    [self.reuseArray removeObject:targetView];
    [self.usingArray addObject:targetView];
    //为即将展示的item赋值
    LSHomeBannerItemLayer* nextDisplayView = [self dequeueReusableItemView];
    [nextDisplayView configWithData:self.dataArray[self.currentIndex]];

}

-(void)animationDidStart:(CAAnimation *)anim target:(LSHomeBannerItemLayer *)targetView
{
    self.gestureEnable = NO;
//    NSLog(@"Next:%@",targetView);
//    //计数增加
//    self.currentIndex++;
//    if (self.currentIndex > self.dataArray.count - 1) {
//        self.currentIndex = 0;//循环
//    }
//  
//    //从可复用数组移除 添加到正在使用数组
//    [self.reuseArray removeObject:targetView];
//    [self.usingArray addObject:targetView];
//    //为即将展示的item赋值
//    LSHomeBannerItemView* nextDisplayView = [self dequeueReusableItemView];
//    [nextDisplayView configWithData:self.dataArray[self.currentIndex]];

    
    
}


-(void)animationDidStop:(CAAnimation *)anim target:(LSHomeBannerItemLayer *)targetView finished:(BOOL)flag
{
    self.gestureEnable = YES;
    //动画完成从使用数组移除  放入可重用数组 并且放回默认位置
    [self.usingArray removeObject:targetView];
    [self.reuseArray addObject:targetView];
    [self resetViewPosition:targetView];
    //刷新页码
    self.pageView.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex + 1,(unsigned long)self.dataArray.count];
  
}





#pragma mark -  LL

-(UIView *)maskGestureView
{
    if (!_maskGestureView) {
        _maskGestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300,200)];
        _maskGestureView.backgroundColor = [UIColor clearColor];
        _maskGestureView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self addSubview:_maskGestureView];

        UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_maskGestureView addGestureRecognizer:pgr];
        UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [_maskGestureView addGestureRecognizer:tgr];
        
        self.pageView.center = CGPointMake(_maskGestureView.bounds.size.width/2, _maskGestureView.bounds.size.height-20/2 -10);
        [_maskGestureView addSubview:self.pageView];

        
    }
    return _maskGestureView;
}


-(UIView *)pageView
{
    if (!_pageView) {
        _pageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        _pageView.font = [UIFont systemFontOfSize:10];
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

-(void)dealloc
{
    LSDeallocLog(self);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
