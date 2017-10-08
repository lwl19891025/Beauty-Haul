//
//  BlogCommentTableViewCell.m
//  Beautyhaul
//
//  Created by liuweiliang on 2017/10/3.
//  Copyright © 2017年 beauty-haul. All rights reserved.
//

#import "BlogCommentTableViewCell.h"
#import <YYLabel.h>

@interface BlogCommentTableViewCell()
@property (strong, nonatomic) UIImageView *avatorView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *replyButton;
@property (strong, nonatomic) UILabel *commentLabel;
@property (strong, nonatomic) YYLabel *repliesLabel;
@end

static CGSize avatorSize = (CGSize){50, 50};
static CGSize buttonSize = (CGSize){20, 20};

@implementation BlogCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.avatorView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.replyButton];
        [self.contentView addSubview:self.commentLabel];
        [self.contentView addSubview:self.repliesLabel];
        self.separatorInset = UIEdgeInsetsMake(0, 80, 0, 20);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.avatorView.frame = (CGRect){20, 20, avatorSize};
    self.nameLabel.frame = (CGRect){80, 20, 200, 16};
    self.replyButton.frame = (CGRect){CGRectGetWidth(self.contentView.bounds) - 20 - buttonSize.width, 20, buttonSize};
    
    CGRect commentRect = [[self.comment objectForKey:@"commentRect"] CGRectValue];
    self.commentLabel.frame = (CGRect){80, 42, [BlogCommentTableViewCell widthForCommentAndReplies], commentRect.size.height};
    
    CGFloat replyOriginY = MAX(CGRectGetMaxY(self.commentLabel.frame) + 10, avatorSize.height+10);
    YYTextLayout *layout = [self.comment objectForKey:@"repliesLayout"];
    self.repliesLabel.textLayout = layout;
    self.repliesLabel.frame = (CGRect){80, replyOriginY,[BlogCommentTableViewCell widthForCommentAndReplies], layout.textBoundingSize.height};
}

- (void)setComment:(NSDictionary *)comment{
    _comment = comment;
    self.commentLabel.text = comment[@"comment"];
    if ([comment objectForKey:@"attributedReplies"]) {
        YYTextLayout *layout = [comment objectForKey:@"repliesLayout"];
        self.repliesLabel.textLayout = layout;
        self.repliesLabel.attributedText = [comment objectForKey:@"attributedReplies"];
    }
    self.avatorView.image = [UIImage imageNamed:comment[@"avator"]];
    self.nameLabel.text = comment[@"name"];
}

- (UIImageView *)avatorView{
    if (!_avatorView) {
        _avatorView = [[UIImageView alloc] init];
//        _avatorView.layer.cornerRadius = avatorSize.width/2.;
    }
    return _avatorView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.];
    }
    return _nameLabel;
}

- (UILabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.numberOfLines = 0;
        _commentLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.];
        _commentLabel.font = [UIFont fontWithName:@"PingFang SC" size:14.];
    }
    return _commentLabel;
}

- (UIButton *)replyButton{
    if (!_replyButton) {
        _replyButton = [[UIButton alloc] init];
        [_replyButton setImage:[UIImage imageNamed:@"reply"] forState:UIControlStateNormal];
    }
    return _replyButton;
}

- (YYLabel *)repliesLabel{
    if (!_repliesLabel) {
        _repliesLabel = [[YYLabel alloc] init];
        _repliesLabel.backgroundColor = [UIColor colorWithWhite:248./255 alpha:1.];
        _repliesLabel.layer.cornerRadius = 4;
        _repliesLabel.numberOfLines = 0;
        _repliesLabel.displaysAsynchronously = YES;
    }
    return _repliesLabel;
}

+ (CGFloat)widthForCommentAndReplies{
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    width -= 80;//left offset
    width -= 20;//right offset
    return width;
}

@end
