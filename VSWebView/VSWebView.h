//
//  VSWebView.h
//  VSWebView
//
//  Created by Leeyan on 12-9-9.
//  Copyright (c) 2012年 Leeyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VSWebView : UIView <UIWebViewDelegate>

@property(nonatomic, assign) id<UIWebViewDelegate> delegate;

- (BOOL)addTarget:(id)target action:(SEL)action forEventName:(NSString *)eventName scheme:(NSString *)scheme;

@end
