//
//  RootViewController.m
//  BEO
//
//  Created by liuweiliang on 2017/9/11.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "RootViewController.h"
#import "IntroductionViewController.h"
#import "UIViewController+Content.h"
#import "BHTabBarController.h"
#import "LoginViewController.h"

@interface RootViewController ()<IntroductionViewDelegate>
@property (weak, nonatomic) UIViewController *introductionVC;
@property (weak, nonatomic) LoginViewController *loginVC;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    IntroductionViewController *introductionVC = [[IntroductionViewController alloc] init];
    introductionVC.delegate = self;
    [self displayChildViewController:introductionVC];
    self.introductionVC = introductionVC;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIViewController *)childViewControllerForStatusBarHidden{
    if (self.introductionVC) {
        return self.introductionVC;
    }
    else if (self.loginVC){
        return self.loginVC;
    }
    return nil;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - IntroductionViewDelegate
- (void)continueLoginWithFacebook:(IntroductionViewController *)vc{
    [UIView animateWithDuration:0.25 animations:^{
        vc.view.alpha = 0;
    } completion:^(BOOL finished) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self displayChildViewController:loginVC];
        [self hidesChildViewController:vc];
        self.introductionVC = nil;
        self.loginVC = loginVC;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)continueLoginWithEmail:(IntroductionViewController *)vc{
    [UIView animateWithDuration:0.25 animations:^{
        vc.view.alpha = 0;
    } completion:^(BOOL finished) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self displayChildViewController:loginVC];
        [self hidesChildViewController:vc];
        self.introductionVC = nil;
        self.loginVC = loginVC;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)skipIntroduction:(IntroductionViewController *)vc{
    [UIView animateWithDuration:0.25 animations:^{
        vc.view.alpha = 0;
    } completion:^(BOOL finished) {
        BHTabBarController *mainVC = [[BHTabBarController alloc] init];
        [self displayChildViewController:mainVC];
        [self hidesChildViewController:vc];
        self.introductionVC = nil;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

@end
