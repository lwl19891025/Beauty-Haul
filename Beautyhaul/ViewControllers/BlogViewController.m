//
//  BlogViewController.m
//  BEO
//
//  Created by liuweiliang on 2017/9/14.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "BlogViewController.h"
#import "ActionListView.h"
#import "FlexibleTextView.h"
#import "CommentPreviewController.h"
#import "BlogContentViewController.h"

#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

@interface BlogViewController ()<ActionListViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) FlexibleTextView *textView;

@property (strong, nonatomic) NSArray *actions;
@property (weak, nonatomic) CommentPreviewController *commentViewController;
@property (weak, nonatomic) BlogContentViewController *contentViewController;
@end


@implementation BlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BeautyHaul’s";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationItem];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.likeButton];
    [self.view addSubview:self.textView];
    BlogContentViewController *blogContentVC = [BlogContentViewController new];
    [blogContentVC willMoveToParentViewController:self];
    [self.scrollView addSubview:blogContentVC.view];
    [self addChildViewController:blogContentVC];
    self.contentViewController = blogContentVC;
    
    CommentPreviewController *previewVC = [CommentPreviewController new];
    previewVC.scrollEnabled = NO;
    [previewVC willMoveToParentViewController:self];
    [self.scrollView addSubview:previewVC.view];
    [self addChildViewController:previewVC];
    self.commentViewController = previewVC;
    [self generateMockData];
}

- (void)generateMockData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"blog.xml" ofType:nil];
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
    self.contentViewController.blogURL = fileURL;
    self.commentViewController.comments = blogComments;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    CGFloat contentHeight = [self.contentViewController heightForFit];
    self.contentViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), contentHeight);
    CGFloat commentHeight = [self.commentViewController heightForFit];
    self.commentViewController.view.frame = CGRectMake(0, contentHeight + 20, CGRectGetWidth(self.view.bounds), commentHeight);
    self.likeButton.frame = (CGRect){CGRectGetWidth(self.view.bounds)-70, CGRectGetHeight(self.view.bounds)-110, 50, 50};
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(self.commentViewController.view.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - actions
- (void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share:(id)sender{
    
}

- (void)more:(id)sender{
    if (!self.actions) {
        self.actions = @[@{@"actionName":@"Save",
                           @"image":@"Save"},
                         @{@"actionName":@"Edit",
                           @"image":@"Edit"},
                         @{@"actionName":@"Report",
                           @"image":@"Report",
                           @"textColor":[UIColor colorWithRed:0xFE/255. green:0x38/255. blue:0x24/255. alpha:1.]},
                         @{@"actionName":@"Delete",
                           @"image":@"Delete",
                           @"textColor":[UIColor colorWithRed:0xFE/255. green:0x38/255. blue:0x24/255. alpha:1.]},
                         ];

    }
    ActionListView *actionsView = [ActionListView viewWithActionInfos:self.actions];
    actionsView.delegate = self;
    [actionsView show];
}

- (void)toggleLikeStatus:(UIButton *)button{
    button.selected = !button.selected;
}

#pragma mark - ActionListViewDelegate
- (void)actionListView:(ActionListView *)view didSelectAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            [self reportBlog];
            break;
        case 3:
            [self deleteBlog];
            break;
        default:
            break;
    }
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

- (void)setupNavigationItem{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button"] style:UIBarButtonItemStylePlain target:self action:@selector(pop:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *moreButton = [[UIButton alloc] init];
    [moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [shareButton sizeToFit];
    [moreButton sizeToFit];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [contentView addSubview:shareButton];
    [contentView addSubview:moreButton];
    shareButton.frame = CGRectMake(0, 0, 25, 44);
    moreButton.frame = CGRectMake(25, 0, 25, 44);
    
    UIBarButtonItem *contentItem = [[UIBarButtonItem alloc] initWithCustomView:contentView];
    
    [self.navigationItem setRightBarButtonItem:contentItem];
}

- (void)reportBlog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Report"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 270, 60)];
    contentView.backgroundColor = [UIColor redColor];
    [alert addAction:cancelAction];
    
    [alert.view addSubview:contentView];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)deleteBlog{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"are you sure you want to Report this note？"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"Delete note" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:comfirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)updateContentView{

//    self.scrollView.contentSize = CGSizeMake(kScreenWidth, layout.textBoundingSize.height + 90 + 20 + 52 + 59 + 1000);
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - getters and setters
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor colorWithWhite:248./255 alpha:1.];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        UIEdgeInsets insets = _scrollView.contentInset;
        insets.bottom = 49;
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _scrollView.contentInset = insets;
    }
    return _scrollView;
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
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, .5)];
        separator.backgroundColor = [UIColor colorWithWhite:0xE6/255. alpha:1.];
        [_textView addSubview:separator];
    }
    return _textView;
}

@end
