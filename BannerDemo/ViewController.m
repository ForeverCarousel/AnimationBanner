//
//  ViewController.m
//  BannerDemo
//
//  Created by Carouesl on 2016/12/26.
//  Copyright © 2016年 Chenxiaolong. All rights reserved.
//

#import "ViewController.h"
#import "LSHomeBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = [UIScreen mainScreen].bounds.size;
    LSHomeBannerView* a = [[LSHomeBannerView alloc] initWithFrame:CGRectMake(0, 0, size.width, 300)];
    [self.view addSubview:a];

    
    NSDictionary* dic = LSJSONConfig(@"testContent");
    [a configWithData:dic];
}


id LSJSONConfig(NSString *fileName){
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:nil];
    NSData *resultData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
    return resultJSON;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
