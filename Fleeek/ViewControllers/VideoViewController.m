//
//  VideoViewController.m
//  Fleeek
//
//  Created by liuweiliang on 2017/9/14.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "VideoViewController.h"
#import "PageMenuView.h"
#import "BlogContentViewController.h"
#import "CommentPreviewController.h"
#import "FlexibleTextView.h"

@import AVKit;
@import AVFoundation;

@interface VideoViewController ()<UIScrollViewDelegate, PageMenuViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIScrollView *tabPageView;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) FlexibleTextView *textView;
@property (strong, nonatomic) PageMenuView *menuView;
@property (strong, nonatomic) AVPlayerViewController *playerViewController;
@property (strong, nonatomic) BlogContentViewController *contentViewController;
@property (strong, nonatomic) CommentPreviewController *commentViewController;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.likeButton];
    [self.view addSubview:self.textView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    [playerViewController willMoveToParentViewController:self];
    [self.scrollView addSubview:playerViewController.view];
    [self addChildViewController:playerViewController];
    self.playerViewController = playerViewController;
    
    [self.scrollView addSubview:self.tabPageView];
    [self generateMockData];
    [self.scrollView addSubview:self.menuView];
    self.menuView.menus = @[@"Overview", @"Steps"];
}

- (void)generateMockData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videoblog.xml" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    NSArray *blogComments = @[@{@"name":@"Haperion",
                                @"avator":@"Haperion",
                                @"comment":@"Well… NaugtyDog is a North American company,so if isn’t worldwide, why would you be surprised? They can’t tweet to NA people only.",
                                @"replies":@[@{@"author":@"Lisa",
                                               @"content":@"They have fans of the game all across the world."},
                                             @{@"author":@"Haperion",
                                               @"replyTo":@"Lisa",
                                               @"content":@"They have fans of the game all across the world."},
                                             @{@"author":@"Lisa",
                                               @"content":@""}]},
                              @{@"name":@"La Galerie Design",
                                @"avator":@"La Galerie Design",
                                @"comment":@"Enfin…",
                                @"replies":@[@{@"author":@"Andrea Navarro",
                                               @"content":@"They have fans of the game all across the world."}]},
                              @{@"name":@"Andrea Navarro",
                                @"avator":@"Andrea Navarro",
                                @"comment":@"Marine Vacth,wow,again one of my favactr..Yayy! Beautyyy,best news ever for me!! Omg!!!!💗"},
                              @{@"name":@"ttya",
                                @"avator":@"ttya",
                                @"comment":@"Is the strobe lighting to detract us form the prict tag?💶"}];
    
    BlogContentViewController *blogContentVC = [BlogContentViewController new];
    blogContentVC.showMoreButton = YES;
    [blogContentVC willMoveToParentViewController:self];
    blogContentVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), [blogContentVC heightForFit]);
    [self.tabPageView addSubview:blogContentVC.view];
    [self addChildViewController:blogContentVC];
    self.contentViewController = blogContentVC;
    
    CommentPreviewController *previewVC = [CommentPreviewController new];
    previewVC.scrollEnabled = NO;
    [previewVC willMoveToParentViewController:self];
//    previewVC.view.frame = CGRectMake(0, [blogContentVC heightForFit], CGRectGetWidth(self.view.bounds), [previewVC heightForFit]);
    [self.tabPageView addSubview:previewVC.view];
    [self addChildViewController:previewVC];
    self.commentViewController = previewVC;
    
    self.contentViewController.blogURL = fileURL;
    __weak typeof(self) wself = self;
    self.contentViewController.finishLayoutBlock = ^{
        __strong VideoViewController *sself = wself;
        CGFloat contentHeight = 530;
        CGFloat commentHeight = [sself.commentViewController heightForFit];
        CGFloat width = CGRectGetWidth(sself.view.bounds);
        sself.tabPageView.frame = CGRectMake(0, 254, width, contentHeight+commentHeight);
        sself.contentViewController.view.frame = CGRectMake(0, 0, width, contentHeight);
        sself.commentViewController.view.frame = CGRectMake(0, contentHeight, width, commentHeight);
        sself.tabPageView.contentSize = CGSizeMake(2*width, contentHeight + commentHeight);
        sself.scrollView.contentSize = CGSizeMake(width, 254 + contentHeight + commentHeight);
    };
    
    self.contentViewController.expandContentBlock = ^(CGFloat heightForFit) {
        __strong VideoViewController *sself = wself;
        CGFloat commentHeight = [sself.commentViewController heightForFit];
        CGFloat width = CGRectGetWidth(sself.view.bounds);
        sself.tabPageView.frame = CGRectMake(0, 254, width, heightForFit+commentHeight);
        [UIView animateWithDuration:0.25 animations:^{
            sself.contentViewController.view.frame = CGRectMake(0, 0, width, heightForFit);
            sself.commentViewController.view.frame = CGRectMake(0, heightForFit, width, commentHeight);
        }];
        sself.tabPageView.contentSize = CGSizeMake(2*width, heightForFit + commentHeight);
        sself.scrollView.contentSize = CGSizeMake(width, 254 + heightForFit + commentHeight);
    };
    self.commentViewController.comments = blogComments;
//    CGFloat height = [self.contentViewController heightForFit] + [self.commentViewController heightForFit];
    
//    self.tabPageView.frame = CGRectMake(0, 254, CGRectGetWidth(self.view.bounds), height);
//    self.tabPageView.contentSize = CGSizeMake(2 * CGRectGetWidth(self.view.bounds), height);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //    self.playerViewController.player = [AVPlayer playerWithURL:[NSURL URLWithString:@"https://devimages.apple.com.edgekey.net/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8"]];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    self.playerViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 210);
    self.menuView.frame = CGRectMake(0, 210, CGRectGetWidth(self.view.bounds), 44);
    self.scrollView.contentSize = self.view.bounds.size;
    self.likeButton.frame = (CGRect){CGRectGetWidth(self.view.bounds)-70, CGRectGetHeight(self.view.bounds)-110, 50, 50};
    CGFloat contentHeight = [self.contentViewController heightForFit];
    CGFloat commentHeight = [self.commentViewController heightForFit];
    self.tabPageView.frame = CGRectMake(0, 254, CGRectGetWidth(self.view.bounds), contentHeight+commentHeight);
    self.contentViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), contentHeight);
    self.commentViewController.view.frame = CGRectMake(0, contentHeight, CGRectGetWidth(self.view.bounds), commentHeight);
    self.tabPageView.contentSize = CGSizeMake(2*CGRectGetWidth(self.view.bounds), contentHeight + commentHeight);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 254 + contentHeight + commentHeight);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0 ) {
        self.menuView.selectedIndex = 0;
//        CGFloat height = [self.contentViewController heightForFit];
//        self.tabPageView.frame = CGRectMake(0, 254, CGRectGetWidth(self.view.bounds), height);
//        self.tabPageView.contentSize = CGSizeMake(2*CGRectGetWidth(self.view.bounds), height);
    } else if (scrollView.contentOffset.x == CGRectGetWidth(scrollView.bounds)){
        self.menuView.selectedIndex = 1;
//        CGFloat height = [self.commentViewController heightForFit];
//        self.tabPageView.frame = CGRectMake(0, 254, CGRectGetWidth(self.view.bounds), height);
//        self.tabPageView.contentSize = CGSizeMake(2*CGRectGetWidth(self.view.bounds), height);
    }
}

#pragma mark - UIScrollViewDelegate PageMenuViewDelegate
- (void)pageMenuView:(PageMenuView *)menuView didSelectedAtIndex:(NSInteger)index{
    [self.tabPageView setContentOffset:CGPointMake(index * CGRectGetWidth(self.view.bounds), 0) animated:YES];
//    CGFloat height = index == 0 ? [self.contentViewController heightForFit] : [self.commentViewController heightForFit];
//    self.tabPageView.frame = CGRectMake(0, 254, CGRectGetWidth(self.view.bounds), height);
//    self.tabPageView.contentSize = CGSizeMake(2*CGRectGetWidth(self.view.bounds), height);
}
#pragma mark - UITextViewDelegaet
- (void)textViewDidChange:(UITextView *)textView{
    static CGFloat maxHeight = 100;
    static CGFloat minHeight = 44;
    
    CGFloat height = [self.textView heightThatFitsText];
    CGFloat oldHeight = self.textView.bounds.size.height;
    
    if (height > maxHeight) {
        textView.scrollEnabled = YES;
    }
    else if (height >= minHeight){
        textView.scrollEnabled = NO;
        if (height != oldHeight) {
            CGRect textViewFrame = self.textView.frame;
            textViewFrame.origin.y -= height - oldHeight;
            textViewFrame.size.height += height - oldHeight;
            [self.textView setFrame:textViewFrame];
        }
    } else {
        CGRect textViewFrame = self.textView.frame;
        textViewFrame.origin.y -= minHeight - oldHeight;
        textViewFrame.size.height += minHeight - oldHeight;
        [self.textView setFrame:textViewFrame];
    }
}

#pragma mark - privates
- (void)toggleLikeStatus:(UIButton *)button{
    button.selected = !button.selected;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSUInteger options = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect frame = [self.view convertRect:keyboardFrame fromView:[UIApplication sharedApplication].keyWindow];
    CGRect endFrame = self.textView.frame;
    endFrame.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(frame) - CGRectGetHeight(endFrame);
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.textView.frame = endFrame;
    } completion:NULL];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSUInteger options = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect endFrame = self.textView.frame;
    endFrame.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(endFrame);
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.textView.frame = endFrame;
    } completion:NULL];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIScrollView *)tabPageView{
    if (!_tabPageView) {
        _tabPageView = [[UIScrollView alloc] init];
        _tabPageView.pagingEnabled = YES;
        _tabPageView.bounces = NO;
        _tabPageView.delegate = self;
        _tabPageView.showsVerticalScrollIndicator = NO;
    }
    return _tabPageView;
}

- (PageMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[PageMenuView alloc] init];
        _menuView.delegate = self;
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.layer.shadowOffset = CGSizeMake(0, 3.);
        _menuView.layer.shadowOpacity = 0.125;
    }
    return _menuView;
}

- (UIButton *)likeButton{
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] init];
        [_likeButton setImage:[UIImage imageNamed:@"unmarkedLike"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"markedLike"] forState:UIControlStateSelected];
        [_likeButton addTarget:self action:@selector(toggleLikeStatus:) forControlEvents:UIControlEventTouchUpInside];
        _likeButton.layer.shadowOpacity = 0.25;
        _likeButton.layer.shadowRadius = 8;
        _likeButton.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _likeButton;
}

- (FlexibleTextView *)textView{
    if (!_textView) {
        _textView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FlexibleTextView class]) owner:nil options:nil] firstObject];
        _textView.frame = (CGRectMake(0, CGRectGetHeight(self.view.bounds)-44, CGRectGetWidth(self.view.bounds), 44));
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:16.];
        _textView.textColor = [UIColor colorWithWhite:0.2 alpha:1.];
        _textView.delegate = self;
        _textView.placeholder = @"Add a comment";
        
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [sendButton setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [leftButton setImage:[UIImage imageNamed:@"addcomment"] forState:UIControlStateNormal];
        
        [_textView setLeftView:leftButton];
        [_textView setRightView:sendButton];
    }
    return _textView;
}

@end
