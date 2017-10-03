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

@implementation BlogCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
