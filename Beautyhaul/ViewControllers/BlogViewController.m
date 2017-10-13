//
//  BlogViewController.m
//  BEO
//
//  Created by liuweiliang on 2017/9/14.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "BlogViewController.h"
#import <YYText.h>
#import "BHXMLParser.h"
#import "BlogLikesViewController.h"
#import "ActionListView.h"
#import "FlexibleTextView.h"
#import "CommentPreviewController.h"
#import "ProductView.h"

@interface BlogLikesView : UIControl

@property (strong, nonatomic) NSArray *likes;

@end


@interface BlogViewController ()<ActionListViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) UIImageView *avatorImageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *clockImageView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) YYLabel *richTextLabel;
@property (strong, nonatomic) BlogLikesView *likesView;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) FlexibleTextView *textView;

@property (strong, nonatomic) NSArray *blogContent;
@property (strong, nonatomic) NSArray *blogComments;

@property (strong, nonatomic) NSArray *actions;
@property (weak, nonatomic) CommentPreviewController *commentPreviewVC;
@end

#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

static NSString *const cellReuseID = @"commentCell";

@implementation BlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BeautyHaul’s";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationItem];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.likeButton];
    [self.view addSubview:self.textView];
    
    [self.scrollView addSubview:self.avatorImageView];
    [self.scrollView addSubview:self.nameLabel];
    [self.scrollView addSubview:self.clockImageView];
    [self.scrollView addSubview:self.timeLabel];
    [self.scrollView addSubview:self.richTextLabel];
    CommentPreviewController *previewVC = [CommentPreviewController new];
    [previewVC willMoveToParentViewController:self];
    [self.scrollView addSubview:previewVC.view];
    [self addChildViewController:previewVC];
    self.commentPreviewVC = previewVC;
    [self.scrollView addSubview:self.likesView];
    
    self.timeLabel.text = @"9:16 AM";
    self.nameLabel.text = @"Carol Rios";
    [self generateMockData];
    previewVC.comments = self.blogComments;
}

- (void)generateMockData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"blog.xml" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    self.blogComments = @[@{@"name":@"Haperion",
                            @"avator":@"Haperion",
                            @"comment":@"Well… NaugtyDog is a North American company,so if isn’t worldwide, why would you be surprised? They can’t tweet to NA people only.",
                            @"replies":@[@{@"author":@"Lisa",
                                           @"content":@"They have fans of the game all across the world."},
                                         @{@"author":@"Haperion",
                                           @"replyTo":@"Lisa",
                                           @"content":@"They have fans of the game all across the world."},
                                         @{@"author":@"Lisa",
                                           @"content":@""}]
                            },
                          @{@"name":@"La Galerie Design",
                            @"avator":@"La Galerie Design",
                            @"comment":@"Enfin…",
                            @"replies":@[@{@"author":@"Andrea Navarro",
                                           @"content":@"They have fans of the game all across the world."}]
                            },
                          @{@"name":@"Andrea Navarro",
                            @"avator":@"Andrea Navarro",
                            @"comment":@"Marine Vacth,wow,again one of my favactr..Yayy! Beautyyy,best news ever for me!! Omg!!!!💗",
                            },
                          @{@"name":@"ttya",
                            @"avator":@"ttya",
                            @"comment":@"Is the strobe lighting to detract us form the prict tag?💶",
                            }];
    
    __weak typeof(self) weakSelf = self;
    [BHXMLParser parseContentsOfURL:fileURL completion:^(NSArray *result) {
        __strong BlogViewController *strongSelf = weakSelf;
        strongSelf.blogContent = result;
        [strongSelf updateContentView];
    }];
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
    self.avatorImageView.frame = CGRectMake(20, 20, 50, 50);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+10, 25, 200, 20);
    self.clockImageView.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+10, 49, 16, 16);
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.clockImageView.frame)+5, 49, 200, 16);
    CGSize textSize = self.richTextLabel.textLayout.textBoundingSize;
    self.richTextLabel.frame = (CGRect){20, 90, textSize};
    self.likesView.frame = (CGRect){0, CGRectGetMaxY(self.richTextLabel.frame) + 20, kScreenWidth, 52};
    CGFloat height = [self.commentPreviewVC heightForFit];
    self.commentPreviewVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.likesView.frame), kScreenWidth, height);
    self.likeButton.frame = (CGRect){CGRectGetWidth(self.view.bounds)-70, CGRectGetHeight(self.view.bounds)-110, 50, 50};
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(self.commentPreviewVC.view.frame));
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

- (void)showAllLikes:(id)sender{
    BlogLikesViewController *likesVC = [[BlogLikesViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:likesVC animated:YES];
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
    UIEdgeInsets insets = (UIEdgeInsets){0,20,0,20};
    __block NSMutableAttributedString *content = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    style.paragraphSpacing = 20;
    
    UIColor *textColor = [UIColor colorWithWhite:0.2 alpha:1.];
    
    UIFont *titleFont = [UIFont systemFontOfSize:26.];
    UIFont *contentFont = [UIFont systemFontOfSize:16.];
    UIFont *subtitleFont = [UIFont systemFontOfSize:20.];
    CGFloat labelWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - insets.left - insets.right;
    
    NSDictionary *titleAttrs = @{NSFontAttributeName:titleFont, NSForegroundColorAttributeName:textColor};
    NSDictionary *contentAttrs = @{NSFontAttributeName:contentFont, NSForegroundColorAttributeName:textColor};
    NSDictionary *subtitleAttr = @{NSFontAttributeName:subtitleFont, NSForegroundColorAttributeName:textColor};
    
    [self.blogContent enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"element"] isEqualToString:@"title"]) {
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:obj[@"text"] attributes:titleAttrs];
            [content appendAttributedString:title];
        }
        else if ([obj[@"element"] isEqualToString:@"p"]){
            NSAttributedString *paragraph = [[NSAttributedString alloc] initWithString:obj[@"text"] attributes:contentAttrs];
            [content appendAttributedString:paragraph];
        }
        else if ([obj[@"element"] isEqualToString:@"image"]){
            NSDictionary *attributes = obj[@"attributes"];
            if ([attributes[@"type"] isEqualToString:@"product"]) {
                CGSize size = (CGSize){labelWidth, 80};
                ProductView *view = [[ProductView alloc] initWithFrame:(CGRect){0, 0, size}];
                view.imageView.image = [UIImage imageNamed:attributes[@"imageName"]];
                view.brandLabel.text = attributes[@"brand"];
                view.nameLabel.text = attributes[@"name"];
                NSAttributedString *productString = [NSAttributedString yy_attachmentStringWithContent:view
                                                                                           contentMode:UIViewContentModeCenter
                                                                                        attachmentSize:size
                                                                                           alignToFont:contentFont
                                                                                             alignment:YYTextVerticalAlignmentCenter];
                [content appendAttributedString:productString];
            }
            else {
                CGFloat height = labelWidth/[attributes[@"aspectRatio"] floatValue];
                CGSize size = CGSizeMake(labelWidth, height);
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, size}];
                imageView.layer.cornerRadius = 8.;
                imageView.layer.masksToBounds = YES;
                imageView.image = [UIImage imageNamed:attributes[@"imageName"]];
                NSAttributedString *imageString = [NSAttributedString yy_attachmentStringWithContent:imageView
                                                                                         contentMode:UIViewContentModeCenter
                                                                                      attachmentSize:size
                                                                                         alignToFont:contentFont
                                                                                           alignment:YYTextVerticalAlignmentCenter];
                [content appendAttributedString:imageString];
            }
        }
        else if ([obj[@"element"] isEqualToString:@"br"]){
            CGSize size = (CGSize){labelWidth, .5};
            UIView *separator = [[UIView alloc] initWithFrame:(CGRect){0, 0, size}];
            separator.backgroundColor = [UIColor colorWithWhite:0xE6/255. alpha:1.];
            NSAttributedString *separatorString = [NSAttributedString yy_attachmentStringWithContent:separator
                                                                                         contentMode:UIViewContentModeCenter
                                                                                      attachmentSize:size
                                                                                         alignToFont:contentFont
                                                                                           alignment:YYTextVerticalAlignmentCenter];
            [content appendAttributedString:separatorString];
        }
        else if ([obj[@"element"] isEqualToString:@"h4"]){
            NSAttributedString *subtitle = [[NSAttributedString alloc] initWithString:obj[@"text"] attributes:subtitleAttr];
            [content appendAttributedString:subtitle];
        }
        [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
    }];
    
    [content yy_setParagraphStyle:style range:NSMakeRange(0, content.length)];
    CGSize size = CGSizeMake(labelWidth, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:content];
    self.richTextLabel.textLayout = layout;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, layout.textBoundingSize.height + 90 + 20 + 52 + 59 + 1000);
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - getters and setters
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        UIEdgeInsets insets = _scrollView.contentInset;
        insets.bottom = 49;
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _scrollView.contentInset = insets;
    }
    return _scrollView;
}

- (UIImageView *)avatorImageView{
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avator_blog"]];
    }
    return _avatorImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithRed:154/255. green:142/255. blue:243/255. alpha:1.];
        _nameLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    }
    return _nameLabel;
}

- (UIImageView *)clockImageView{
    if (!_clockImageView) {
        _clockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock"]];
    }
    return _clockImageView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.];
        _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    }
    return _timeLabel;
}

- (YYLabel *)richTextLabel{
    if (!_richTextLabel) {
        _richTextLabel = [YYLabel new];
        _richTextLabel.displaysAsynchronously = YES;
        _richTextLabel.userInteractionEnabled = YES;
        _richTextLabel.numberOfLines = 0;
        _richTextLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    }
    return _richTextLabel;
}

- (BlogLikesView *)likesView{
    if (!_likesView) {
        _likesView = [[BlogLikesView alloc] init];
        [_likesView addTarget:self action:@selector(showAllLikes:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likesView;
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

@implementation BlogLikesView{
    UIView *_topSeparator;
    UIImageView *_imageView;
    UIView *_bottomSeparator;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"followers"]];
        [self addSubview:_imageView];
        
        _topSeparator = [[UIView alloc] init];
        _topSeparator.backgroundColor = [UIColor colorWithWhite:0xE6/255. alpha:1.];
        [self addSubview:_topSeparator];
        
        _bottomSeparator = [[UIView alloc] init];
        _bottomSeparator.backgroundColor = [UIColor colorWithWhite:0xE6/255. alpha:1.];
        [self addSubview:_bottomSeparator];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _topSeparator.frame = CGRectMake(20, 0, CGRectGetWidth(self.bounds), .5);
    _imageView.frame = (CGRect){20 ,14, 219.5, 24};
    _bottomSeparator.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-.5, CGRectGetWidth(self.bounds), .5);
}

- (void)setLikes:(NSArray *)likes{
    _likes = likes;
}

@end

