//
//  ViewController.m
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import "ViewController.h"
#import "LSHomeBannerView.h"
#import "LSAttributeLabel.h"
#import "CarouselFoldView.h"

@interface ViewController ()

@property (strong, nonatomic) LSAttributeLabel* attrLabel;

@property (strong, nonatomic) CarouselFoldView* iconImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.attrLabel = [[LSAttributeLabel alloc] initWithFrame:CGRectMake(20, 350, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    self.attrLabel.font = [UIFont systemFontOfSize:14.0f];
    //    [self.view addSubview:_attrLabel];
    _attrLabel.numberOfLines = 2;
    
    UIButton* btn = [UIButton    buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"模拟删除/添加" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor purpleColor];
    [btn setFrame:CGRectMake(20, 350, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    UIButton* btn2 = [UIButton    buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"模拟刷新" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor purpleColor];
    [btn2 setFrame:CGRectMake(20, 420, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    [btn2 addTarget:self action:@selector(btnPressed2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    self.iconImage = [[CarouselFoldView alloc] initWithFrame:CGRectMake(0, 300, 290, 415)];
    _iconImage.backgroundColor = [UIColor redColor];
    _iconImage.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2 +100);
    _iconImage.image = [UIImage imageNamed:@"Faye"];
    _iconImage.sensitivity = 3.0f;
    //    [self.view addSubview:_iconImage];
    
    
    [self showBanner:YES];
    
    
}


id LSJSONConfig(NSString *fileName){
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:nil];
    NSData *resultData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
    return resultJSON;
}

-(void)showBanner:(BOOL)show
{
    if (show) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        LSHomeBannerView* bannerView = [[LSHomeBannerView alloc] initWithFrame:CGRectMake(0, 0, size.width, 300) selectBlock:^(id info) {
            NSLog(@"点击了：%@",[info objectForKey:@"title"]);
        }];
        bannerView.tag = 1010;
        [self.view addSubview:bannerView];
        NSDictionary* dic = LSJSONConfig(@"testContent");
        [bannerView configWithData:dic];
    }else{
        [[self.view viewWithTag:1010] removeFromSuperview];
    }
}

-(void)btnPressed:(UIButton*)sender
{
    static BOOL a = NO;
    self.attrLabel.isVIP = a;
    NSString* B = @"第三个参数attributes其实就是字符串的属性，是个字典类型的对象";
    //    NSString* B = @"第三个参数";
    _attrLabel.text = B;
    
    
    [self showBanner:a];
    
    
    a = !a;
}

-(void)btnPressed2:(UIButton*)sender
{
    NSDictionary* dic = LSJSONConfig(@"testContent");
    [[self.view viewWithTag:1010] configWithData:dic];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
