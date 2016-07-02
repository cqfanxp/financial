//
//  WebViewController.m
//  financial
//
//  Created by 火爆私厨 on 16/5/7.
//  Copyright © 2016年 聚财道. All rights reserved.
//

#import "WebViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "Public.h"

@interface WebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
    UIWebView *_webView;
    
    UILabel *_titleLabel;
    
    //关闭按钮
    UIButton *_closeBtn;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNav];
    
    [self initLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

#pragma mark 初始化布局
-(void)initLayout{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-64)];
    [self.view addSubview:_webView];
    
    _webView.scalesPageToFit = YES;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, 64 - progressBarHeight, screen_width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self loadWeb];
}

-(void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    backView.backgroundColor = RGB(250, 250, 250);
    [self.view addSubview:backView];
    //下划线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, screen_width, 0.5)];
    lineView.backgroundColor = RGB(192, 192, 192);
    [backView addSubview:lineView];
    
    //返回
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 23)];
    leftImgView.image = [UIImage imageNamed:@"brn_left"];
    
    UILabel *leftLbel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftImgView.frame)+5, 0, 35, 23)];
    leftLbel.text =  @"返回";
    leftLbel.font = [UIFont systemFontOfSize:15];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 30, 50, 23);
    [backBtn addSubview:leftImgView];
    [backBtn addSubview:leftLbel];
//    backBtn.backgroundColor = [UIColor blueColor];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    
    //关闭
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.hidden = YES;
    _closeBtn.frame = CGRectMake(CGRectGetMaxX(backBtn.frame)+5, 30, 40, 23);
    [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [_closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    closeBtn.backgroundColor = [UIColor redColor];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:_closeBtn];
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-80, 30, 160, 30)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    //    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = _webModel.title;
    [backView addSubview:_titleLabel];
    
//    //收藏
//    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    collectBtn.frame = CGRectMake(screen_width-10-23, 30, 22, 22);
//    [collectBtn setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
//    [collectBtn setImage:[UIImage imageNamed:@"icon_collect_highlighted"] forState:UIControlStateHighlighted];
//    [backView addSubview:collectBtn];
//    
//    //分享
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.frame = CGRectMake(screen_width-10-23-10-23, 30, 22, 22);
//    [shareBtn setImage:[UIImage imageNamed:@"icon_merchant_share_normal"] forState:UIControlStateNormal];
//    [shareBtn setImage:[UIImage imageNamed:@"icon_merchant_share_highlighted"] forState:UIControlStateHighlighted];
//    [shareBtn addTarget:self action:@selector(OnShareBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:shareBtn];
    
    
}
-(void)loadWeb
{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_webModel.url]];
    [_webView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark 返回上一级
-(void)back{
    if (_webView.canGoBack) {
        [_webView goBack];
        _closeBtn.hidden = NO;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 关闭
-(void)close{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
