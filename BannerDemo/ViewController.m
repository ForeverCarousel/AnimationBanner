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

@interface ViewController ()

@property (strong, nonatomic) LSAttributeLabel* attrLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = [UIScreen mainScreen].bounds.size;
    LSHomeBannerView* a = [[LSHomeBannerView alloc] initWithFrame:CGRectMake(0, 0, size.width, 300)];
    [self.view addSubview:a];
    
    NSDictionary* dic = LSJSONConfig(@"testContent");
    [a configWithData:dic];
    
    
    self.attrLabel = [[LSAttributeLabel alloc] initWithFrame:CGRectMake(20, 350, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    self.attrLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_attrLabel];
    _attrLabel.numberOfLines = 2;
    
}


id LSJSONConfig(NSString *fileName){
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:nil];
    NSData *resultData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
    return resultJSON;
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static BOOL a = YES;
    self.attrLabel.isVIP = a;
    NSString* B = @"第三个参数attributes其实就是字符串的属性，是个字典类型的对象";
//    NSString* B = @"第三个参数";
    _attrLabel.text = B;
    
    
    a = !a;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
