//
//  CommentPreviewController.m
//  Beautyhaul
//
//  Created by liuweiliang on 2017/10/13.
//  Copyright © 2017年 beauty-haul. All rights reserved.
//

#import "CommentPreviewController.h"
#import <YYLabel.h>

@interface CommentPreviewSectionHeader : UITableViewHeaderFooterView
@property (strong, nonatomic) UIImageView *avatorView;
@property (strong, nonatomic) UIImageView *replyView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) YYLabel *commentLabel;
@property (strong, nonatomic) UIControl *control;
@end

@interface CommentPreviewSectionFooter : UITableViewHeaderFooterView

@end

@interface CommentPreviewTableViewCell : UITableViewCell
@property (strong, nonatomic) YYLabel *replyLabel;
@end

@interface CommentPreviewHeaderView : UIView
@property (strong, nonatomic) UILabel *textLabel;
@end

@interface CommentPreviewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *layouts;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) CommentPreviewHeaderView *headerView;
@end



#pragma mark - CommentPreviewController Implementation

static NSString *const kCommentPreviewCellReuseId = @"CommentPreviewCell";
static NSString *const kCommentPreviewSectionHeaderReuseId = @"CommentPreviewSectionHeader";
static NSString *const kCommentPreviewSectionFooterReuseId = @"CommentPreviewSectionFooter";
static CGSize kAvatorImageSize = (CGSize){50, 50};
static CGFloat marginLeftRight = 20.;

@implementation CommentPreviewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _scrollEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44);
    CGRect frame = self.view.bounds;
    frame.origin.y = 44;
    frame.size.height -= 44;
    self.tableView.frame = frame;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (CGFloat)heightForFit{
    return self.tableView.contentSize.height + 44;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.maxCountToDisplay) {
        return MIN(self.maxCountToDisplay, self.comments.count);
    }
    return self.comments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * replies = [self.comments[section] objectForKey:@"replies"];
    return [replies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentPreviewCellReuseId forIndexPath:indexPath];
    NSArray * replyLayouts = [self.layouts[indexPath.section] objectForKey:@"replyLayouts"];
    cell.replyLabel.textLayout = replyLayouts[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(tableView.bounds), 0, 0);
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CommentPreviewSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCommentPreviewSectionHeaderReuseId];
    NSDictionary *comment = self.comments[section];
    header.avatorView.image = [UIImage imageNamed:comment[@"avator"]];
    header.nameLabel.text = comment[@"name"];
    YYTextLayout *layout = [self.layouts[section] objectForKey:@"commentLayout"];
    header.commentLabel.textLayout = layout;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CommentPreviewSectionFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCommentPreviewSectionFooterReuseId];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYTextLayout *layout = [[self.layouts[indexPath.section] objectForKey:@"replyLayouts"] objectAtIndex:indexPath.row];
    return ceil(layout.textBoundingSize.height) + 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    YYTextLayout *layout = [self.layouts[section] objectForKey:@"commentLayout"];
    return ceil(layout.textBoundingSize.height) + 22 + 20 + 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

#pragma mark - getters and setters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = _scrollEnabled;
        [_tableView registerClass:[CommentPreviewTableViewCell class] forCellReuseIdentifier:kCommentPreviewCellReuseId];
        [_tableView registerClass:[CommentPreviewSectionHeader class] forHeaderFooterViewReuseIdentifier:kCommentPreviewSectionHeaderReuseId];
        [_tableView registerClass:[CommentPreviewSectionFooter class] forHeaderFooterViewReuseIdentifier:kCommentPreviewSectionFooterReuseId];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 23;
            _tableView.estimatedSectionHeaderHeight = 50;
        }
    }
    return _tableView;
}

- (CommentPreviewHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[CommentPreviewHeaderView alloc] init];
    }
    return _headerView;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled = scrollEnabled;
    _tableView.scrollEnabled = scrollEnabled;
}

- (void)setMaxCountToDisplay:(NSInteger)maxCountToDisplay{
    _maxCountToDisplay = maxCountToDisplay;
    [self.tableView reloadData];
}

- (void)setComments:(NSArray *)comments{
    _comments = comments;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *layouts = [NSMutableArray new];
        CGFloat textWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - marginLeftRight - kAvatorImageSize.width - 10 - marginLeftRight;
        CGSize textSize = CGSizeMake(textWidth, CGFLOAT_MAX);
        
        [comments enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull comment, NSUInteger idx, BOOL * _Nonnull stop) {
            
            YYTextContainer *commentContainer = [YYTextContainer containerWithSize:textSize];
            NSAttributedString *attributedComment = [[NSAttributedString alloc] initWithString:comment[@"comment"]
                                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.]}];
            
            YYTextLayout *commentLayout = [YYTextLayout layoutWithContainer:commentContainer text:attributedComment];
            NSMutableDictionary *layout = [NSMutableDictionary new];
            layout[@"commentLayout"] = commentLayout;
            
            __block NSMutableArray *replyLayouts = [NSMutableArray new];
            
            [comment[@"replies"] enumerateObjectsUsingBlock:^(id  _Nonnull reply, NSUInteger idx, BOOL * _Nonnull stop) {
                YYTextContainer *replyContainer = [YYTextContainer containerWithSize:textSize];
                NSMutableAttributedString *attributedReply = [NSMutableAttributedString new];
                NSAttributedString *author = [[NSAttributedString alloc] initWithString:reply[@"author"]
                                                                             attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0x9A/255. green:0x8E/255. blue:0xF3/255. alpha:1.]}];
                [attributedReply appendAttributedString:author];
                
                if (reply[@"replyTo"]) {
                    NSAttributedString *prefixRe = [[NSAttributedString alloc] initWithString:@" re " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.2 alpha:1.]}];
                    NSAttributedString *replyTo = [[NSAttributedString alloc] initWithString:reply[@"replyTo"] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0x9A/255. green:0x8E/255. blue:0xF3/255. alpha:1.]}];
                    [attributedReply appendAttributedString:prefixRe];
                    [attributedReply appendAttributedString:replyTo];
                }
                [attributedReply addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12. weight:UIFontWeightMedium]} range:NSMakeRange(0, attributedReply.length)];
                NSString *content = [NSString stringWithFormat:@" :%@", reply[@"content"]];
                NSAttributedString *attrcontent = [[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.2 alpha:1.], NSFontAttributeName:[UIFont systemFontOfSize:12.]}];
                [attributedReply appendAttributedString:attrcontent];
                YYTextLayout *replyLayout = [YYTextLayout layoutWithContainer:replyContainer text:attributedReply];
                [replyLayouts addObject:replyLayout];
            }];
            layout[@"replyLayouts"] = replyLayouts;
            [layouts addObject:layout];
        }];
        self.layouts = layouts;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.headerView.textLabel.text = [NSString stringWithFormat:@"%@ Comments", @(self.comments.count)];
            [self.tableView reloadData];
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        });
    });
}

@end



#pragma mark - Table Header View Implementation
@implementation CommentPreviewHeaderView{
    __weak UIImageView *_imageView;
    __weak UIView *_separator;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commentcount"]];
        [self addSubview:imageView];
        _imageView = imageView;
        [self addSubview:self.textLabel];
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = [UIColor colorWithWhite:230./255 alpha:1.];
        [self addSubview:separator];
        _separator = separator;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(20, 12, 20, 20);
    CGFloat lineHeight = ceil(_textLabel.font.lineHeight);
    _textLabel.frame = CGRectMake(50, 14, CGRectGetWidth(self.bounds) - 50 - 20, lineHeight);
    _separator.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-0.5, CGRectGetWidth(self.bounds), 0.5);
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.];
        _textLabel.font = [UIFont systemFontOfSize:14. weight:UIFontWeightMedium];
    }
    return _textLabel;
}
@end


#pragma mark - Section Header Implementation
@implementation CommentPreviewSectionHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.control];
        [self.control addSubview:self.avatorView];
        [self.control addSubview:self.nameLabel];
        [self.control addSubview:self.commentLabel];
        [self.control addSubview:self.replyView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = CGRectInset(self.contentView.bounds, 20, 20);
    self.control.frame = frame;
    self.avatorView.frame = (CGRect){0, 0, kAvatorImageSize};
    self.nameLabel.frame = (CGRect){kAvatorImageSize.width + 10, 0, 100, 16};
    self.replyView.frame = (CGRect){CGRectGetWidth(self.control.bounds) - 20 - 20, 20, 20};
    YYTextLayout *layout = self.commentLabel.textLayout;
    self.commentLabel.frame = (CGRect){kAvatorImageSize.width + 10, 22, layout.textBoundingSize};
}

#pragma mark - actions
- (void)controlDidClick:(id)sender{
    
}

#pragma mark - getters and setters
- (UIControl *)control{
    if (!_control) {
        _control = [[UIControl alloc] init];
        [_control addTarget:self action:@selector(controlDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _control;
}

- (UIImageView *)avatorView{
    if (!_avatorView) {
        _avatorView = [UIImageView new];
    }
    return _avatorView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.];
        _nameLabel.font = [UIFont systemFontOfSize:14. weight:UIFontWeightMedium];
    }
    return _nameLabel;
}

- (YYLabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel = [YYLabel new];
        _commentLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.];
        _commentLabel.font = [UIFont systemFontOfSize:14.];
        _commentLabel.displaysAsynchronously = YES;
    }
    return _commentLabel;
}

- (UIImageView *)replyView{
    if (!_replyView) {
        _replyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reply"]];
    }
    return _replyView;
}

@end



#pragma mark - Cell Implementation
@implementation CommentPreviewTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.replyLabel];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.replyLabel.frame = (CGRect){80, 0, self.replyLabel.textLayout.textBoundingSize};
}

- (YYLabel *)replyLabel{
    if (!_replyLabel) {
        _replyLabel = [YYLabel new];
        _replyLabel.displaysAsynchronously = YES;
    }
    return _replyLabel;
}
@end




#pragma mark - Section Footer Implementation
@implementation CommentPreviewSectionFooter{
    __weak UIView *_separator;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIView *separator = [UIView new];
        separator.backgroundColor = [UIColor colorWithWhite:230./255 alpha:1.];
        [self.contentView addSubview:separator];
        _separator = separator;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _separator.frame = CGRectMake(80, CGRectGetHeight(self.contentView.bounds)-0.5, CGRectGetWidth(self.contentView.bounds)-100, 0.5);
}
@end
