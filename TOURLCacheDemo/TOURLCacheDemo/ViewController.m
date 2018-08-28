//
//  ViewController.m
//  TOURLCacheDemo
//
//  Created by TonyJR on 2018/8/28.
//  Copyright © 2018年 TonyJR. All rights reserved.
//

#import "ViewController.h"
#import "TOURLCache.h"

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSDate *date;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webView = [UIWebView new];
    self.webView.delegate = self;
    self.webView.frame = self.view.bounds;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"普通方式刷新页面" style:UIBarButtonItemStyleDone target:self action:@selector(nomarlLoadPage)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"缓存方式刷新页面" style:UIBarButtonItemStyleDone target:self action:@selector(cacheLoadPage)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)nomarlLoadPage{
    [NSURLProtocol unregisterClass:[TOURLCacheProtocol class]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/TonyJR/TOURLCache"]]];
}

- (void)cacheLoadPage{
    [NSURLProtocol registerClass:[TOURLCacheProtocol class]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/TonyJR/TOURLCache"]]];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.date = [NSDate new];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"网页加载用时%f秒",[[NSDate new] timeIntervalSinceDate:self.date]);
}

@end
