//
//  ThirdIntroductionViewController.m
//  BEO
//
//  Created by liuweiliang on 2017/9/16.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "ThirdIntroductionViewController.h"

static CGSize kLoginButtonSize = (CGSize){285, 52};

@interface ThirdIntroductionViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton * faceBookLoginButton;
@property (strong, nonatomic) UIButton * emailLoginButton;
@end

@implementation ThirdIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.faceBookLoginButton];
    [self.view addSubview:self.emailLoginButton];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat maxWidth = CGRectGetWidth(self.view.bounds);
    self.imageView.frame = self.view.bounds;
    self.emailLoginButton.frame = (CGRect){(maxWidth-kLoginButtonSize.width)/2., 172, kLoginButtonSize};
    self.faceBookLoginButton.frame = (CGRect){(maxWidth-kLoginButtonSize.width)/2., 172 + kLoginButtonSize.height + 10, kLoginButtonSize};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)loginWithFacebook:(id)sender{
    !self.loginWithFaceBook ? : self.loginWithFaceBook();
}

- (void)loginWithEmail:(id)sender{
    !self.loginWithEmail ? : self.loginWithEmail();
}

#pragma mark - getters
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"introduction3"]];
    }
    return _imageView;
}

- (UIButton *)faceBookLoginButton{
    if (!_faceBookLoginButton) {
        _faceBookLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceBookLoginButton addTarget:self action:@selector(loginWithFacebook:) forControlEvents:UIControlEventTouchUpInside];
        _faceBookLoginButton.layer.cornerRadius = kLoginButtonSize.height/2.;
    }
    return _faceBookLoginButton;
}

- (UIButton *)emailLoginButton{
    if (!_emailLoginButton) {
        _emailLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emailLoginButton addTarget:self action:@selector(loginWithEmail:) forControlEvents:UIControlEventTouchUpInside];
        _emailLoginButton.layer.cornerRadius = kLoginButtonSize.height/2.;
    }
    return _emailLoginButton;
}

@end
