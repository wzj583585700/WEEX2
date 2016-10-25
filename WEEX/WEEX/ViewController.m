//
//  ViewController.m
//  WEEX
//
//  Created by mac on 2016/10/25.
//  Copyright © 2016年 Wei ZhiJun. All rights reserved.
//

#import "ViewController.h"
#import <WeexSDK/WXSDKInstance.h>
@interface ViewController ()
//WXSDKInstance属性
@property (nonatomic, strong) WXSDKInstance *instance;
//URL属性(用于指定加载js的URL,一般声明在接口中,我们为了测试方法写在了类扩展中.)
@property (nonatomic, strong) NSURL *url;
//Weex视图
@property (weak, nonatomic) UIView *weexView;
@end

@implementation ViewController
- (NSURL *)url {
    if (!_url) {
        _url =  [[NSBundle mainBundle] URLForResource:@"list"   withExtension:@"js"];
    }
    return _url;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _instance = [[WXSDKInstance alloc] init];
    
    _instance.viewController = self;
    
    _instance.frame = self.view.frame;
    
    [_instance renderWithURL:self.url options:@{@"bundleUrl":[self.url absoluteString]} data:nil];
    
    __weak typeof(self) weakSelf = self;
    
    _instance.onCreate = ^(UIView *view) {
        weakSelf.weexView = view;
        [weakSelf.weexView removeFromSuperview];
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    
    _instance.onFailed = ^(NSError *error) {
        //process failure
        NSLog(@"处理失败:%@",error);
    };
    
    _instance.renderFinish = ^ (UIView *view) {
        //process renderFinish
        NSLog(@"渲染完成");
    };

}

- (void)dealloc {
    //  销毁WXSDKInstance实例
    [self.instance destroyInstance];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
