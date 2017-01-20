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

@property (strong, nonatomic) NSMutableArray<LSHomeBannerItemView*>* reuseArray;
@property (strong, nonatomic) NSMutableArray<LSHomeBannerItemView*>* usingArray;

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
        self.reuseArray = [NSMutableArray arrayWithCapacity:LSHBI_CREAT_COUNT_MAX];
        self.usingArray = [NSMutableArray arrayWithCapacity:LSHBI_CREAT_COUNT_MAX];

        self.dataArray = [NSMutableArray array];
        self.currentIndex = 0;
        for (int i = 0; i < LSHBI_CREAT_COUNT_MAX; ++i) {
            LSHomeBannerItemView* itemView = [[LSHomeBannerItemView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
            itemView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
            itemView.delegate = self;
            [self.reuseArray addObject:itemView];
            //需要都添加视图 用于下面逻辑判断
            [self addSubview:itemView];
        }
        
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
    self.currentIndex = 0;
    [self stopTimer];
    NSMutableArray* bannerArray = [[[data objectForKey:@"data"] firstObject] objectForKey:@"items"];
    
    [bannerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* imageURL = [obj objectForKey:@"logo"];
        if(idx < 4){
            [self.dataArray addObject:imageURL];
        }else{
            *stop = YES;
        }
    }];
    //立即给第一张图赋值
    [self.reuseArray[0] configWithData:self.dataArray[0]];
    [self startTimer];
}


-(void)resetViewPosition:(LSHomeBannerItemView*) view
{
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
    view.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    if (view.superview == nil) {
        [self addSubview:view];
    }
    [self sendSubviewToBack:view];
//    [CATransaction commit];

}


-(LSHomeBannerItemView* )dequeueReusableItemView
{
    LSHomeBannerItemView* reuseItem = [self.reuseArray firstObject];
    return reuseItem? : nil;
}



#pragma mark - Animation Delegate


-(void)animationDidStart:(CAAnimation *)anim target:(LSHomeBannerItemView *)targetView
{
    NSLog(@"Next:%@",targetView);
    //计数增加
    self.currentIndex++;
    if (self.currentIndex > self.dataArray.count - 1) {
        self.currentIndex = 0;//循环
    }
  
    //从可复用数组移除 添加到正在使用数组
    [self.reuseArray removeObject:targetView];
    [self.usingArray addObject:targetView];
    //为即将展示的item赋值
    LSHomeBannerItemView* nextDisplayView = [self dequeueReusableItemView];
    [nextDisplayView configWithData:self.dataArray[self.currentIndex]];

    
    
}


-(void)animationDidStop:(CAAnimation *)anim target:(LSHomeBannerItemView *)targetView finished:(BOOL)flag
{

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

-(void)dealloc
{
    NSLog(@"%@ is Dealloc",self);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
