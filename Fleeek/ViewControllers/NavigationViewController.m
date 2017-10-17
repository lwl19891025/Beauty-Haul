//
//  NavigationViewController.m
//  Fleeek
//
//  Created by liuweiliang on 2017/9/11.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTintColor:[UIColor colorWithWhite:0.4 alpha:1.0]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.4 alpha:1.],
                                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17.]}];
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = self.viewControllers.count > 0;
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
