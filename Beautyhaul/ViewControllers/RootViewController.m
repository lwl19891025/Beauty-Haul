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

@interface RootViewController ()<IntroductionViewDelegate, LoginViewDelegate>
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
    return self.childViewControllers.firstObject;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark - IntroductionViewDelegate
- (void)continueLoginWithFacebook:(IntroductionViewController *)vc{
//    [UIView animateWithDuration:0.25 animations:^{
//
//    } completion:^(BOOL finished) {
//        
//    }];
}

- (void)continueLoginWithEmail:(IntroductionViewController *)vc{
    [UIView animateWithDuration:0.25 animations:^{
        vc.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self requireSigninOrUp];
    }];
}

- (void)skipIntroduction:(IntroductionViewController *)vc{
    [UIView animateWithDuration:0.25 animations:^{
        vc.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self requireSigninOrUp];
    }];
}

#pragma mark - LoginViewDelegate
- (void)loginViewDidGoBack:(LoginViewController *)loginViewController{
    [self hidesChildViewController:loginViewController];
    self.loginVC = nil;
    self.introductionVC.view.alpha = 1;
}

- (void)loginViewDidSignin:(LoginViewController *)loginViewController{
    [UIView animateWithDuration:0.25 animations:^{
        loginViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        BHTabBarController *mainVC = [[BHTabBarController alloc] init];
        [self displayChildViewController:mainVC];
        [self hidesChildViewController:self.loginVC];
        [self hidesChildViewController:self.introductionVC];
        self.introductionVC = nil;
        self.loginVC = nil;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

#pragma mark - privates
- (void)requireSigninOrUp{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self displayChildViewController:loginVC];
    loginVC.delegate = self;
    self.loginVC = loginVC;
}

@end
