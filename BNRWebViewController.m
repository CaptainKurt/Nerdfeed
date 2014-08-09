//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by Kurt Walker on 8/9/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIToolbar *tBar;

@end

@implementation BNRWebViewController

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

- (void)configureToolbar
{
    UIWebView *webView = (UIWebView *)self.view;
    
    CGRect tFrame=CGRectMake(0,self.view.bounds.size.height-50, self.view.bounds.size.width, 50);
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:tFrame];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"MenuIndicator@2x.png"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(buttonPressed:)];
    backButton.tag = 0;
    backButton.enabled = webView.canGoBack;
    
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc]
                                      initWithImage:[UIImage imageNamed:@"PlusSpool@2x.png"]
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(buttonPressed:)];
    forwardButton.tag = 1;
    forwardButton.enabled = webView.canGoForward;
    
    NSArray *items = @[backButton,
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                       forwardButton];
    
    toolBar.items = items;
    
    self.tBar = toolBar;
    
    [self.view addSubview:self.tBar];
}

- (void)buttonPressed:(id)sender
{
    //cast button from sender
    UIBarButtonItem *button=(UIBarButtonItem *)sender;
    //cast webview from view
    UIWebView *webview=(UIWebView *)self.view;
    //use tags to move forward/back
    if (button.tag==1) {
        [webview goForward];
    }else{
        [webview goBack];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //get array from toolbar property items array
    NSArray *items=self.tBar.items;
    //get buttons from array
    UIBarButtonItem *backButton=items[0];
    UIBarButtonItem *forwardButton=items[2];
    //set buttons enabled from webview properties
    backButton.enabled=webView.canGoBack;
    forwardButton.enabled=webView.canGoForward;
    [self configureToolbar];
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.tBar removeFromSuperview];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self configureToolbar];
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
    }
}

@end
