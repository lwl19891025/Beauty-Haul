//
//  SecondIntroductionViewController.m
//  Fleeek
//
//  Created by liuweiliang on 2017/9/12.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "SecondIntroductionViewController.h"

@interface SecondIntroductionViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation SecondIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.scrollView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.imageView.frame = self.view.bounds;
    self.scrollView.frame = (CGRect){0, CGRectGetHeight(self.view.bounds)/2 - 100, CGRectGetWidth(self.view.bounds), 200};
    self.scrollView.contentSize = CGSizeMake(1000, CGRectGetHeight(self.view.bounds));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor colorWithRed:250./255 green:90./255 blue:75./255 alpha:1.];
        _scrollView.scrollEnabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"introduction2"]];
    }
    return _imageView;
}

@end
