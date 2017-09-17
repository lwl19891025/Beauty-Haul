//
//  IntroductionViewController.m
//  BEO
//
//  Created by liuweiliang on 2017/9/11.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "IntroductionViewController.h"
#import "UIViewController+Content.h"
#import "FirstIntroductionViewController.h"
#import "SecondIntroductionViewController.h"
#import "ThirdIntroductionViewController.h"

@interface IntroductionViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *skipButton;
@property (strong, nonatomic) NSArray *viewControllers;

@end
static CGSize kSkipButtonSize = (CGSize){30, 30};
static CGFloat kSkipButtonTopMargin = 15;
static CGFloat kSkipButtonRightMargin = 15;

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.skipButton];
    [self setupChildVCs];
}

- (void)setupChildVCs{
    FirstIntroductionViewController *firstIntroduction = [[FirstIntroductionViewController alloc] init];
    SecondIntroductionViewController *secondIntroduction = [[SecondIntroductionViewController alloc] init];
    ThirdIntroductionViewController *thirdIntroduction = [[ThirdIntroductionViewController alloc] init];
    
    [self addIntroductionItemVC:firstIntroduction];
    [self addIntroductionItemVC:secondIntroduction];
    [self addIntroductionItemVC:thirdIntroduction];
    
    __weak typeof(self) weakSelf = self;
    thirdIntroduction.loginWithEmail = ^{
        __strong typeof(self) strongSelf = weakSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(continueLoginWithEmail:)]) {
            [strongSelf.delegate continueLoginWithEmail:strongSelf];
        }
    };
    
    thirdIntroduction.loginWithFaceBook = ^{
        __strong typeof(self) strongSelf = weakSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(continueLoginWithFacebook:)]) {
            [strongSelf.delegate continueLoginWithFacebook:strongSelf];
        }
    };
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    self.scrollView.frame = bounds;
    NSInteger count = self.childViewControllers.count;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(bounds)*count, CGRectGetHeight(bounds));

    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *_Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        vc.view.frame = CGRectMake(idx*CGRectGetWidth(bounds), 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    }];
    CGPoint skipButtonOrigin = (CGPoint){CGRectGetWidth(bounds) - kSkipButtonRightMargin - kSkipButtonSize.width, kSkipButtonTopMargin};
    self.skipButton.frame = (CGRect){skipButtonOrigin, kSkipButtonSize};
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)skipButtonDidClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(skipIntroduction:)]) {
        [self.delegate skipIntroduction:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addIntroductionItemVC:(__kindof UIViewController *)vc{
    [self addChildViewController:vc];
    [self.scrollView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UIButton *)skipButton{
    if (!_skipButton) {
        _skipButton = [[UIButton alloc] init];
        [_skipButton addTarget:self
                        action:@selector(skipButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}
@end
