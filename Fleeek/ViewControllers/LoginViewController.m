//
//  LoginViewController.m
//  Fleeek
//
//  Created by liuweiliang on 2017/9/11.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "LoginViewController.h"
#import "SignInOrUpView.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *signInOrUpButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) SignInOrUpView *signupView;
@property (strong, nonatomic) SignInOrUpView *signinView;
@property (strong, nonatomic) SignInOrUpView *createNicknameView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.signInOrUpButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - actions
- (void)doneButtonClick:(id)sender{
    static BOOL registed = YES;
    if ([self.signInOrUpButton isEqual:sender]) {
        if (registed) {
            [self displayContentView:self.signinView];
        }
        else {
            [self displayContentView:self.signupView];
        }
        registed = !registed;
    }
    else if ([_signinView.doneButton isEqual:sender]){
        //sign in success
        if ([self.delegate respondsToSelector:@selector(loginViewDidSignin:)]) {
            [self.delegate loginViewDidSignin:self];
        }
    }
    else if ([_signupView.doneButton isEqual:sender]){
        [self displayContentView:self.createNicknameView];
    }
    else if ([_createNicknameView.doneButton isEqual:sender]){
        //sign in success
        if ([self.delegate respondsToSelector:@selector(loginViewDidSignin:)]) {
            [self.delegate loginViewDidSignin:self];
        }
    }
}

- (void)backButtonClick:(UIButton *)sender{
    if ([self.backButton isEqual:sender]) {
        if ([self.delegate respondsToSelector:@selector(loginViewDidGoBack:)]) {
            [self.delegate loginViewDidGoBack:self];
        }
    }
    else if ([_signinView.backButton isEqual:sender]) {
        [self removeContentView:self.signinView];
    }
    else if ([_signupView.backButton isEqual:sender]){
        [self removeContentView:self.signupView];
    }
    else if([_createNicknameView.backButton isEqual:sender]){
        [self removeContentView:self.createNicknameView];
    }
}

- (void)resendCode:(id)sender{
    //resend code
}

#pragma mark - privates
- (void)displayContentView:(UIView *)view{
    [self.view addSubview:view];
    view.frame = (CGRect){CGRectGetWidth(self.view.bounds),0, self.view.bounds.size};
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        view.frame = self.view.bounds;
    }];
}

- (void)removeContentView:(UIView *)view{
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = (CGRect){CGRectGetWidth(self.view.bounds),0, self.view.bounds.size};
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

#pragma mark - getters
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.placeholder = @"enter your email";
        _textField.textColor = [UIColor whiteColor];
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, 285, 0.5)];
        bottomLine.backgroundColor = [UIColor whiteColor];
        [_textField addSubview:bottomLine];
    }
    return _textField;
}

- (UIButton *)signInOrUpButton{
    if (!_signInOrUpButton) {
        _signInOrUpButton = [[UIButton alloc] init];
        [_signInOrUpButton setTitle:@"Sign in/Sign up" forState:UIControlStateNormal];
        [_signInOrUpButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signInOrUpButton;
}

- (SignInOrUpView *)signinView{
    if (!_signinView) {
        _signinView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SignInOrUpView class]) owner:nil options:nil] firstObject];
        [_signinView.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_signinView.resendButton addTarget:self action:@selector(resendCode:) forControlEvents:UIControlEventTouchUpInside];
        [_signinView.doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _signinView.welcomeLabel.text = [NSString stringWithFormat:@"Welcome back! To sign in, enter the 6-digit code we send to %@", self.textField.text];
        _signinView.nicknameView.hidden = YES;
        [_signinView.doneButton setTitle:@"Sign in" forState:UIControlStateNormal];
    }
    return _signinView;
}

- (SignInOrUpView *)signupView{
    if (!_signupView) {
        _signupView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SignInOrUpView class]) owner:nil options:nil] firstObject];
        [_signupView.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_signupView.resendButton addTarget:self action:@selector(resendCode:) forControlEvents:UIControlEventTouchUpInside];
        [_signupView.doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _signupView.nicknameLabel.text = @"Hi there,";
        _signupView.welcomeLabel.text = [NSString stringWithFormat:@"Nice to meet you! To create a new account, enter the 6-digit code we send to %@.", self.textField.text];
        _signupView.nicknameView.hidden = YES;
        [_signupView.doneButton setTitle:@"Sign up" forState:UIControlStateNormal];
    }
    return _signupView;
}

- (SignInOrUpView *)createNicknameView{
    if (!_createNicknameView) {
        _createNicknameView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SignInOrUpView class]) owner:nil options:nil] firstObject];
        [_createNicknameView.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_createNicknameView.doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _createNicknameView.welcomeLabel.text = @"Almost there! Create a username. Don't stress, you can change it any time.";
        _createNicknameView.codeView.hidden = YES;
        _createNicknameView.resendButton.hidden = YES;
        [_createNicknameView.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    }
    return _createNicknameView;
}

@end
