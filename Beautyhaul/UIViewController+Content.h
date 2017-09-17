//
//  UIViewController+Content.h
//  BEO
//
//  Created by liuweiliang on 2017/9/11.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Content)
- (void)displayChildViewController:(UIViewController *)vc;
- (void)hidesChildViewController:(UIViewController *)vc;
@end
