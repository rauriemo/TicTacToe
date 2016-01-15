//
//  WebViewVC.m
//  TicTacToe
//
//  Created by Rafael Auriemo on 1/15/16.
//  Copyright © 2016 Rafael Auriemo. All rights reserved.
//

#import "WebViewVC.h"

@interface WebViewVC () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    [self loadURL:@"https://en.wikipedia.org/wiki/Tic-tac-toe"];
    // Do any additional setup after loading the view.
}

-(void) loadURL:(NSString *)urlString {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

-(void) webViewDidStartLoad:(UIWebView *)webView{
    [self.activityIndicator startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
}

- (IBAction)exitModalButtonTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
