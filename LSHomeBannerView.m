//
//  LSHomeBannerView.m
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import "LSHomeBannerView.h"
#import "LSHomeBannerItemView.h"
#import "LSHomeBannerAnimation.h"
#import "LSWeakProxy.h"

#define LSHBI_CREAT_COUNT_MAX   2

#define LSHBI_AUTO_FLOW_TIME    3.0f

#define LSHBI_ANIMATION_LEFT_KEY   @"111"
#define LSHBI_ANIMATION_RIGHT_KEY  @"222"

@interface LSHomeBannerView()<LSHomeBannerAnimationDelegate>

@property (strong, nonatomic) NSMutableArray<LSHomeBannerItemView*>* usingArray;
@property (strong, nonatomic) NSMutableArray<LSHomeBannerItemView*>* reuseArray;
@property (strong, nonatomic) NSMutableArray* dataArray;

@property (strong, nonatomic) UIView* maskGestureView;

@property (strong, nonatomic) UILabel* pageView;

@property (strong, nonatomic) LSHomeBannerAnimation* animation;

@property (strong, nonatomic) NSTimer* autoFlowTimer;

@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation LSHomeBannerView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        self.usingArray = [NSMutableArray array];
        self.reuseArray = [NSMutableArray arrayWithCapacity:LSHBI_CREAT_COUNT_MAX];
        self.dataArray = [NSMutableArray array];
        self.animation = [[LSHomeBannerAnimation alloc] initWithDelegate:self];
        self.currentIndex = 0;
        for (int i = 0; i < LSHBI_CREAT_COUNT_MAX; ++i) {
            LSHomeBannerItemView* itemView = [[LSHomeBannerItemView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
            itemView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
          
            [self.reuseArray addObject:itemView];
        }
        
        //默认添加一张
        [self addSubview:self.reuseArray[0]];
        
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
                                                    repeats:NO];
    }
    return _autoFlowTimer;
}




#pragma mark - Action

-(void)panGestureAction:(UIPanGestureRecognizer* )pgr
{
    
    
    
}

-(void)autoFlowAction:(NSTimer* )timer
{
    [self startAnimationOnTarget:[self dequeueReusableItemView] anmation:self.animation.leftAnimation];
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

-(void)startAnimationOnTarget:(LSHomeBannerItemView*)targetView anmation:(CAAnimation*)ani
{
    [targetView.layer removeAllAnimations];
    [targetView.layer addAnimation:ani forKey:nil];
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
    [self.reuseArray[0] configWithData:self.dataArray[0]];
    [self startTimer];
}


-(void)resetResueView:(LSHomeBannerItemView*) view
{
    view.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:view];
    [self sendSubviewToBack:view];
}


-(LSHomeBannerItemView* )dequeueReusableItemView
{
    if (self.reuseArray.count != 0) {
        LSHomeBannerItemView* reuseItem = [self.reuseArray firstObject];
        [reuseItem resetData];
        return reuseItem;
    }else{
        return nil;
    }

}

#pragma - Animation Delegate

-(void)animationDidStart:(CAAnimation *)anim
{
    //取出可重用队列的视图放到即将显示的位置
    LSHomeBannerItemView* nextDisplayView = [self dequeueReusableItemView];
    if (nextDisplayView) {
        [self resetResueView:nextDisplayView];
        [nextDisplayView configWithData:self.dataArray[0]];
        //放入动画数组 从可重用数组移除
        [self.usingArray addObject:nextDisplayView];
        [self.reuseArray removeObject:nextDisplayView];
        
        
    }
    NSLog(@"动画开始 可重用数组：%d  动画数组:%d",self.reuseArray.count,self.usingArray.count);
   
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{

    //将执行完动画的视图移出动画数组 放回可重用队列
    if (flag) {
        LSHomeBannerItemView* temp = self.usingArray[0];
        [temp resetData];
        [self.usingArray removeObjectAtIndex:0];
        
        [self.reuseArray addObject:temp];
        
    }
    NSLog(@"动画结束 可重用数组：%d  动画数组:%d",self.reuseArray.count,self.usingArray.count);

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
