//
//  TestViewController.m
//  VSWebView
//
//  Created by Leeyan on 12-9-9.
//  Copyright (c) 2012年 Leeyan. All rights reserved.
//

#import "TestViewController.h"
#import "VSWebView.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    VSWebView *webView = [[VSWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [webView addTarget:self
                action:@selector(onWenkuTapped:)
          forEventName:@"wk.baidu.com"
                scheme:@"http"];
    NSURLRequest *request = [NSURLRequest
                             requestWithURL:[NSURL
                                             URLWithString:@"http://www.baidu.com"]];
    [webView performSelector:@selector(loadRequest:) withObject:request];
    [self.view addSubview:webView];
    [webView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)onWenkuTapped:(NSDictionary *)params {
    NSLog(@"wenku: %@", params);
}

@end
