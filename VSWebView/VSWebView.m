//
//  VSWebView.m
//  VSWebView
//
//  Created by Leeyan on 12-9-9.
//  Copyright (c) 2012年 Leeyan. All rights reserved.
//

#import "VSWebView.h"

@interface VSWebView ()

@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) NSMutableDictionary *actions;

@end

@implementation VSWebView

@synthesize delegate;
@synthesize actions = _actions;
@synthesize webView;

- (void)dealloc {
    webView.delegate = nil;
    [webView release];
    self.actions = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect webViewFrame = CGRectZero;
        webViewFrame.size = frame.size;
        self.webView = [[[UIWebView alloc] initWithFrame:webViewFrame] autorelease];
        webView.delegate = self;
        [self addSubview:webView];
    }
    return self;
}

- (BOOL)addTarget:(id)target action:(SEL)action forEventName:(NSString *)eventName scheme:(NSString *)scheme {
    NSMethodSignature *sig = [target methodSignatureForSelector:action];
    if (sig) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        invocation.target = target;
        invocation.selector = action;
        
        if (nil == self.actions) {
            self.actions = [NSMutableDictionary dictionary];
        }
        
        NSMutableDictionary *actionDict = (NSMutableDictionary *)[self.actions objectForKey:scheme];
        if (nil == actionDict) {
            actionDict = [NSMutableDictionary dictionary];
        }
        [actionDict setObject:invocation forKey:eventName];
        
        [self.actions setObject:actionDict forKey:scheme];
        
        return YES;
    } else {
        return NO;
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.webView respondsToSelector:aSelector]) {
        return self.webView;
    }
    return nil;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSURL *url = [request URL];
	
    NSString *scheme = [url scheme];
    NSString *event = [url host];
    
    do {
        NSString *keyPath = [NSString stringWithFormat:@"%@.%@", scheme, event];
        NSInvocation *invocation = [self.actions valueForKeyPath:keyPath];
        
        if (nil == invocation || ![invocation isKindOfClass:[NSInvocation class]]) {
            break;
        }
        
        NSString *query = [url query];
        NSArray *sep = [query componentsSeparatedByString:@"&"];
        
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        for (NSString *param in sep) {
            NSArray *sp = [param componentsSeparatedByString:@"="];
            [dictParam setObject:[sp objectAtIndex:1] forKey:[sp objectAtIndex:0]];
        }
        
        [invocation setArgument:&dictParam atIndex:2];
        
        [invocation invoke];
        
    } while (NO);
    
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.delegate webView:webView
           shouldStartLoadWithRequest:request
                       navigationType:navigationType];
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:aWebView];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView {
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:aWebView];
    }
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:aWebView didFailLoadWithError:error];
    }
}

@end
