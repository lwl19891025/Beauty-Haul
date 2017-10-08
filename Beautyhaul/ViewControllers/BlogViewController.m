//
//  BlogViewController.m
//  BEO
//
//  Created by liuweiliang on 2017/9/14.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "BlogViewController.h"
#import <YYText.h>
#import <YYText/NSAttributedString+YYText.h>
#import "BHXMLParser.h"
#import "BlogCommentTableViewCell.h"
#import "BlogLikesViewController.h"
#import "ActionListView.h"
#import "FlexibleTextView.h"

@interface BlogLikesView : UIControl

@property (strong, nonatomic) NSArray *likes;

@end


@interface BlogViewController ()<UITableViewDelegate, UITableViewDataSource, ActionListViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) UIImageView *avatorImageView;
@property (strong, nonatomic) UIScrollView *contentView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *clockImageView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) YYLabel *richTextLabel;
@property (strong, nonatomic) BlogLikesView *likesView;
@property (strong, nonatomic) UIView *commentCountView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) FlexibleTextView *textView;

@property (strong, nonatomic) NSArray *blogContent;
@property (strong, nonatomic) NSArray *blogComments;

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray *viewsForRichText;
@property (assign, nonatomic) CGFloat heightForTableView;

@property (strong, nonatomic) NSArray *actions;
@end

#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

static NSString *const cellReuseID = @"commentCell";

@implementation BlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"BeautyHaul’s";
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [self setupNavigationItem];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.avatorImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.clockImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.richTextLabel];
    [self.contentView addSubview:self.likesView];
    [self.contentView addSubview:self.commentCountView];
    [self.contentView addSubview:self.tableView];
    [self.view addSubview:self.likeButton];
    [self.view addSubview:self.textView];
    
    self.timeLabel.text = @"Carol Rios";
    self.nameLabel.text = @"9:16 AM";
    [self generateMockData];
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
    self.contentView.frame = self.view.bounds;
    self.avatorImageView.frame = CGRectMake(20, 20, 50, 50);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+10, 25, 200, 20);
    self.clockImageView.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+10, 49, 16, 16);
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.clockImageView.frame)+5, 49, 200, 16);
    self.richTextLabel.frame = (CGRect){0, 90, self.richTextLabel.textLayout.textBoundingSize};
    self.likesView.frame = (CGRect){0, CGRectGetMaxY(self.richTextLabel.frame) + 20, kScreenWidth, 52};
    self.commentCountView.frame = CGRectMake(0, CGRectGetMaxY(self.likesView.frame), kScreenWidth, 59);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.commentCountView.frame), kScreenWidth, self.heightForTableView);
    self.likeButton.frame = (CGRect){CGRectGetWidth(self.view.bounds)-70, CGRectGetHeight(self.view.bounds)-110, 50, 50};
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

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.blogComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BlogCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID forIndexPath:indexPath];
    [cell setComment:self.blogComments[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [[self.blogComments[indexPath.row] objectForKey:@"height"] floatValue];
    return height;
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
//    [self showViewController:alert sender:nil];
}

- (void)updateContentView{
    UIEdgeInsets insets = (UIEdgeInsets){0,20,0,20};
    __block NSMutableAttributedString *content = [[NSMutableAttributedString alloc] init];
    [self.blogContent enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"element"] isEqualToString:@"title"]) {
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:obj[@"text"] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:26],
                                                                                                                           NSForegroundColorAttributeName:[UIColor colorWithWhite:0.2 alpha:1.]}];
            NSRange range = NSMakeRange(0, title.length);
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.headIndent = insets.left;
            style.tailIndent = -insets.right;
            style.firstLineHeadIndent = insets.left;
            style.paragraphSpacing = 30;
            [title yy_setParagraphStyle:style range:range];
            [content appendAttributedString:title];
        }
        else if ([obj[@"element"] isEqualToString:@"p"]){
            NSMutableAttributedString *paragraph = [[NSMutableAttributedString alloc] initWithString:obj[@"text"] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:16],
                                                                                                                               NSForegroundColorAttributeName:[UIColor colorWithWhite:0.2 alpha:1.]}];
            NSRange range = NSMakeRange(0, paragraph.length);
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.headIndent = insets.left;
            style.tailIndent = -insets.right;
            style.firstLineHeadIndent = insets.left;
            style.lineSpacing = 5;
            style.paragraphSpacing = 20;
            [paragraph yy_setParagraphStyle:style range:range];
            [content appendAttributedString:paragraph];
        }
        else if ([obj[@"element"] isEqualToString:@"image"]){
            NSDictionary *attributes = obj[@"attributes"];
            
            if ([attributes[@"type"] isEqualToString:@"product"]) {
                
                CGSize size = (CGSize){CGRectGetWidth(self.view.bounds) - insets.left - insets.right, 80};
                
                UIView *productView = [[UIView alloc] initWithFrame:(CGRect){0, 0, size}];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 64, 64)];
                imageView.image = [UIImage imageNamed:attributes[@"imageName"]];
                imageView.layer.cornerRadius = 4;
                
                UIStackView *stackView = [[UIStackView alloc] initWithFrame:(CGRect){CGRectGetMaxX(imageView.frame) + 10, 8, size.width - CGRectGetMaxX(imageView.frame) - 10 - 20 - 46 - 15, size.height - 2 * 8.}];
                stackView.axis = UILayoutConstraintAxisVertical;
                stackView.alignment = UIStackViewAlignmentLeading;
                stackView.distribution = UIStackViewDistributionFillEqually;
                
                UILabel *brandLabel = [[UILabel alloc] init];
                brandLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
                brandLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.];
                brandLabel.text = attributes[@"brand"];
                
                UILabel *nameLabel = [[UILabel alloc] init];
                nameLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.];
                nameLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
                nameLabel.numberOfLines = 0;
                nameLabel.text = attributes[@"name"];
                [stackView addArrangedSubview:brandLabel];
                [stackView addArrangedSubview:nameLabel];
                
                UIButton *viewButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stackView.frame)+20, (size.height-20)/2., 46, 20)];
                [viewButton setBackgroundImage:[UIImage imageNamed:@"viewbutton"] forState:UIControlStateNormal];
                [viewButton setTitle:@"View" forState:UIControlStateNormal];
                viewButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.];
                
                [productView addSubview:imageView];
                [productView addSubview:stackView];
                [productView addSubview:viewButton];
                
                productView.layer.cornerRadius = 8.;
                productView.backgroundColor = [UIColor whiteColor];
                productView.layer.shadowOpacity = .12;
                productView.layer.shadowOffset = CGSizeMake(0, 0);
                productView.layer.shadowRadius = 13.;
                
                NSMutableAttributedString *productString = [NSMutableAttributedString yy_attachmentStringWithContent:productView
                                                                                                         contentMode:UIViewContentModeCenter
                                                                                                      attachmentSize:size
                                                                                                         alignToFont:[UIFont fontWithName:@"Helvetica" size:16]
                                                                                                           alignment:YYTextVerticalAlignmentCenter];
                NSRange range = NSMakeRange(0, productString.length);
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.firstLineHeadIndent = insets.left;
                style.headIndent = insets.left;
                style.tailIndent = -insets.right;
                style.paragraphSpacing = 20;
                [productString yy_setParagraphStyle:style range:range];
                [content appendAttributedString:productString];
            }
            else {
                CGFloat width = CGRectGetWidth(self.view.bounds);
                CGFloat height = width/[attributes[@"aspectRatio"] floatValue];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, width, height}];
                imageView.image = [UIImage imageNamed:attributes[@"imageName"]];
                NSMutableAttributedString *imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView
                                                                                                       contentMode:UIViewContentModeCenter
                                                                                                    attachmentSize:CGSizeMake(width, height)
                                                                                                       alignToFont:[UIFont fontWithName:@"Helvetica" size:16]
                                                                                                         alignment:YYTextVerticalAlignmentCenter];
                
                NSRange range = NSMakeRange(0, imageString.length);
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.paragraphSpacing = 20;
                [imageString yy_setParagraphStyle:style range:range];
                [content appendAttributedString:imageString];
            }
        }
        else if ([obj[@"element"] isEqualToString:@"br"]){
            CGSize size = (CGSize){CGRectGetWidth(self.view.bounds) - insets.left - insets.right, .5};
            UIView *separator = [[UIView alloc] initWithFrame:(CGRect){0, 0, size}];
            separator.backgroundColor = [UIColor colorWithWhite:0xE6/255. alpha:1.];
            
            NSMutableAttributedString *separatorString = [NSMutableAttributedString yy_attachmentStringWithContent:separator
                                                                                                       contentMode:UIViewContentModeCenter
                                                                                                    attachmentSize:size
                                                                                                       alignToFont:[UIFont fontWithName:@"Helvetica" size:16]
                                                                                                         alignment:YYTextVerticalAlignmentCenter];
            NSRange range = NSMakeRange(0, separatorString.length);
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.headIndent = insets.left;
            style.tailIndent = -insets.right;
            style.firstLineHeadIndent = insets.left;
            style.paragraphSpacing = 20;
            [separatorString yy_setParagraphStyle:style range:range];
            [content appendAttributedString:separatorString];
        }
        else if ([obj[@"element"] isEqualToString:@"h4"]){
            NSMutableAttributedString *subtitle = [[NSMutableAttributedString alloc] initWithString:obj[@"text"] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:20],
                                                                                                                              NSForegroundColorAttributeName:[UIColor colorWithWhite:0.2 alpha:1.]}];
            NSRange range = NSMakeRange(0, subtitle.length);
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.headIndent = insets.left;
            style.tailIndent = -insets.right;
            style.firstLineHeadIndent = insets.left;
            style.paragraphSpacing = 10;
            [subtitle yy_setParagraphStyle:style range:range];
            [content appendAttributedString:subtitle];
        }
        [content yy_appendString:@"\n"];
    }];
    
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.bounds), CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:content];
    self.richTextLabel.textLayout = layout;
    self.richTextLabel.attributedText = content;
    
    self.contentView.contentSize = CGSizeMake(kScreenWidth, layout.textBoundingSize.height + 90 + 20 + 52 + 59);
    
    CGFloat width = [BlogCommentTableViewCell widthForCommentAndReplies];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *blogComments = [NSMutableArray new];
        __block CGFloat tableViewHeight = 0;
        [self.blogComments enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *wrapperItem = [item mutableCopy];
            NSString *comment = [item objectForKey:@"comment"];
            
            CGRect commentRect = [comment boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:14]} context:nil];
            commentRect.size.height = ceil(commentRect.size.height);
            [wrapperItem setObject:[NSValue valueWithCGRect:commentRect] forKey:@"commentRect"];
            if ([item[@"replies"] count] == 0) {
                CGFloat heightForCommentCell = 20 + MAX(50, (16 + 6 + commentRect.size.height)) + 20;
                [wrapperItem setObject:@(heightForCommentCell) forKey:@"height"];
                [blogComments addObject:wrapperItem];
                tableViewHeight += heightForCommentCell;
            }
            else {
                NSMutableAttributedString *replies = [NSMutableAttributedString new];
                [item[@"replies"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableAttributedString *attributedReply = [NSMutableAttributedString new];
                    NSDictionary *authorAttrs = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0x9A/255. green:0x8E/255. blue:0xF3/255. alpha:1.]};
                    if (idx >= 2) {
                        NSString *seeMore = [NSString stringWithFormat:@"more %@ replies >", @([item[@"replies"] count])];
                        NSAttributedString *seeMoreReplies = [[NSAttributedString alloc] initWithString:seeMore attributes:authorAttrs];
                        [attributedReply appendAttributedString:seeMoreReplies];
                    }
                    else{
                        NSAttributedString *author = [[NSAttributedString alloc] initWithString:obj[@"author"] attributes:authorAttrs];
                        [attributedReply appendAttributedString:author];
                        if (obj[@"replyTo"]) {
                            NSMutableAttributedString *replyTo = [NSMutableAttributedString new];
                            [replyTo yy_appendString:@" re "];
                            [replyTo addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.2 alpha:1.],} range:NSMakeRange(1, 2)];
                            
                            [replyTo appendAttributedString:[[NSAttributedString alloc] initWithString:obj[@"replyTo"] attributes:authorAttrs]];
                            [attributedReply appendAttributedString:replyTo];
                        }
                        NSString *content = [NSString stringWithFormat:@" :%@", obj[@"content"]];
                        NSDictionary *contentAttrs = @{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.2 alpha:1.]};
                        NSAttributedString *attrContent = [[NSAttributedString alloc] initWithString:content attributes:contentAttrs];
                        [attributedReply appendAttributedString:attrContent];
                    }
                    NSRange range = NSMakeRange(0, attributedReply.length);
                    
                    [attributedReply yy_setLineSpacing:5 range:range];
                    [replies appendAttributedString:attributedReply];
                    if (idx < 2) {
                        [replies yy_appendString:@"\n"];
                    }
                    *stop = (idx >= 2);
                }];
                
                [replies addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:12]} range:NSMakeRange(0, replies.length)];
                
                YYTextContainer *container = [[YYTextContainer alloc] init];
                [container setSize:CGSizeMake(width, CGFLOAT_MAX)];
                [container setInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
                
                YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:replies]; //[YYTextLayout layoutWithContainerSize:CGSizeMake(width, CGFLOAT_MAX) text:replies];
                
                [wrapperItem setObject:layout forKey:@"repliesLayout"];
                [wrapperItem setObject:replies forKey:@"attributedReplies"];
                CGFloat heightForCommentCell = 20 + MAX(50, (16 + 6 + commentRect.size.height)) + 10 + layout.textBoundingSize.height + 20;
                [wrapperItem setObject:@(heightForCommentCell) forKey:@"height"];
                [blogComments addObject:wrapperItem];
                tableViewHeight += heightForCommentCell;
            }
        }];
        self.heightForTableView = tableViewHeight;
        self.blogComments = blogComments;
        dispatch_async(dispatch_get_main_queue(), ^{
            CGSize contentSize = self.contentView.contentSize;
            contentSize.height += self.heightForTableView;//topOffset
            self.contentView.contentSize = contentSize;
            [self.tableView reloadData];
        });
    });
}

#pragma mark - getters and setters

- (UIScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        UIEdgeInsets insets =  _contentView.contentInset;
        insets.bottom = 49;
        _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _contentView.contentInset = insets;
    }
    return _contentView;
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

- (UIView *)commentCountView{
    if (!_commentCountView) {
        _commentCountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 59)];
        _commentCountView.backgroundColor = [UIColor colorWithWhite:248./255 alpha:1.];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, 44)];
        contentView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commentcount"]];
        imageView.frame = CGRectMake(20, 12, 20, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, 100, 16)];
        label.textColor = [UIColor colorWithWhite:0.2 alpha:1.];
        UIFontDescriptor *Descriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorNameAttribute:@"PingFangSC-Medium"}];
        label.font = [UIFont fontWithDescriptor:Descriptor size:14.];
        
        label.text = @"4 Comments";
        [_commentCountView addSubview:contentView];
        [contentView addSubview:imageView];
        [contentView addSubview:label];
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 58.5, kScreenWidth, 0.5)];
        separator.backgroundColor = [UIColor colorWithWhite:230/255. alpha:1.];
        [_commentCountView addSubview:separator];
    }
    return _commentCountView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[BlogCommentTableViewCell class] forCellReuseIdentifier:cellReuseID];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
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

