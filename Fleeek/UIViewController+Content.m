//
//  UIViewController+Content.m
//  Fleeek
//
//  Created by liuweiliang on 2017/9/11.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "UIViewController+Content.h"

@implementation UIViewController (Content)

- (void)displayChildViewController:(UIViewController *)vc{
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    vc.view.frame = self.view.bounds;
    [vc didMoveToParentViewController:self];
}

- (void)hidesChildViewController:(UIViewController *)vc{
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
}

@end
