//
//  VideoViewController.m
//  BEO
//
//  Created by liuweiliang on 2017/9/14.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "VideoViewController.h"
#import "PageMenuView.h"

@interface VideoViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIScrollView *firstTab;
@property (strong, nonatomic) UIScrollView *secondTab;

@property (strong, nonatomic) UIView *placeholderView;
@property (strong, nonatomic) PageMenuView *menuView;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.menuView];
    [self.scrollView addSubview:self.placeholderView];
    [self.scrollView addSubview:self.menuView];
    self.menuView.menus = @[@"Overview", @"Steps"];
    [self.scrollView addSubview:self.firstTab];
    [self.scrollView addSubview:self.secondTab];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.placeholderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 210);
    self.menuView.frame = CGRectMake(0, 210, CGRectGetWidth(self.view.bounds), 44);
    self.scrollView.contentSize = self.view.bounds.size;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)deviceOrientationDidChange:(NSNotification *)notification{
    [UIViewController attemptRotationToDeviceOrientation];
    NSLog(@"%@", [notification.userInfo description]);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)placeholderView{
    if (!_placeholderView) {
        _placeholderView = [[UIView alloc] init];
        _placeholderView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.25];
    }
    return _placeholderView;
}

- (UIScrollView *)firstTab{
    if (!_firstTab) {
        _firstTab = [[UIScrollView alloc] init];
        _firstTab.showsVerticalScrollIndicator = NO;
    }
    return _firstTab;
}

- (UIScrollView *)secondTab{
    if (!_secondTab) {
        _secondTab = [[UIScrollView alloc] init];
        _secondTab.showsVerticalScrollIndicator = NO;
    }
    return _secondTab;
}

- (PageMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[PageMenuView alloc] init];
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.layer.shadowOffset = CGSizeMake(0, 3.);
        _menuView.layer.shadowOpacity = 0.125;
    }
    return _menuView;
}

@end
