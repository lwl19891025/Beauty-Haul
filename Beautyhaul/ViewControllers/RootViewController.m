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
    [self requireSigninOrUp];
    self.loginVC.view.frame = CGRectMake(CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    [UIView animateWithDuration:0.25 animations:^{
        self.loginVC.view.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)skipIntroduction:(IntroductionViewController *)vc{
    [self requireSigninOrUp];
    self.loginVC.view.frame = CGRectMake(CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    [UIView animateWithDuration:0.25 animations:^{
        self.loginVC.view.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - LoginViewDelegate
- (void)loginViewDidGoBack:(LoginViewController *)loginViewController{
    [UIView animateWithDuration:0.25 animations:^{
        self.loginVC.view.frame = CGRectMake(CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    } completion:^(BOOL finished) {
        [self hidesChildViewController:loginViewController];
        self.loginVC = nil;
    }];
}

- (void)loginViewDidSignin:(LoginViewController *)loginViewController{
    UIView *snapshot = [self.view snapshotViewAfterScreenUpdates:NO];
    BHTabBarController *mainVC = [[BHTabBarController alloc] init];
    [self displayChildViewController:mainVC];
    [self hidesChildViewController:self.loginVC];
    [self hidesChildViewController:self.introductionVC];
    self.introductionVC = nil;
    self.loginVC = nil;
    snapshot.frame = self.view.bounds;
    [self.view addSubview:snapshot];
    
    [UIView animateWithDuration:1 animations:^{
        snapshot.transform = CGAffineTransformMakeScale(1.5, 1.5);
        snapshot.alpha = 0.5;
    } completion:^(BOOL finished) {
        [snapshot removeFromSuperview];
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
