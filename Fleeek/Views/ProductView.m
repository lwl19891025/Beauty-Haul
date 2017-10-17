//
//  ProductView.m
//  Fleeek
//
//  Created by liuweiliang on 2017/10/13.
//  Copyright © 2017年 fleeek. All rights reserved.
//

#import "ProductView.h"

@interface ProductView()
@property (strong, nonatomic) UIStackView *stackView;
@end

@implementation ProductView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self addSubview:self.stackView];
        [self addSubview:self.viewButton];
        [self.stackView addArrangedSubview:self.brandLabel];
        [self.stackView addArrangedSubview:self.nameLabel];
        self.layer.cornerRadius = 8.;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowOpacity = .12;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 13.;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    self.imageView.frame = CGRectMake(8, 8, 64, 64);
    CGFloat stackViewOriginX = CGRectGetMaxX(_imageView.frame) + 10;
    self.stackView.frame = (CGRect){stackViewOriginX, 8, size.width - stackViewOriginX - 20 - 46 - 15, size.height - 2 * 8.};
    self.viewButton.frame = CGRectMake(CGRectGetMaxX(_stackView.frame)+20, (size.height-20)/2., 46, 20);
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 4;
    }
    return _imageView;
}

- (UIStackView *)stackView{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentLeading;
        _stackView.distribution = UIStackViewDistributionFillEqually;
    }
    return _stackView;
}

- (UILabel *)brandLabel{
    if (!_brandLabel) {
        _brandLabel = [[UILabel alloc] init];
        _brandLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        _brandLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.];
    }
    return _brandLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.];
        _nameLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UIButton *)viewButton{
    if (!_viewButton) {
        _viewButton = [[UIButton alloc] init];
        [_viewButton setBackgroundImage:[UIImage imageNamed:@"viewbutton"] forState:UIControlStateNormal];
        [_viewButton setTitle:@"View" forState:UIControlStateNormal];
        _viewButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.];
    }
    return _viewButton;
}

@end
