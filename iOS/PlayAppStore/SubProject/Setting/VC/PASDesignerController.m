//
//  PASDesignerController.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/7.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDesignerController.h"

@interface PASDesignerController ()<UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation PASDesignerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PlayAppStore";
    UIWebView *webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.delegate = self;
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    NSString *urlStr = @"https://github.com/playappstore/PlayAppStore";
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
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
