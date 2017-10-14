//
//  BlogContentViewController.m
//  Beautyhaul
//
//  Created by liuweiliang on 2017/10/14.
//  Copyright © 2017年 beauty-haul. All rights reserved.
//

#import <YYText.h>
#import "BHXMLParser.h"
#import "BlogLikesViewController.h"
#import "BlogContentViewController.h"
#import "ProductView.h"

@interface AuthorInfoView : UIView
@property (strong, nonatomic) UIImageView *avatorView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *clockImageView;
@property (strong, nonatomic) UILabel *timeLabel;
@end

@interface BlogLikesView : UIControl
@property (strong, nonatomic) NSArray *likes;
@end

@interface BlogContentViewController ()
@property (strong, nonatomic) AuthorInfoView *authorInfoView;
@property (strong, nonatomic) YYLabel *contentLabel;
@property (strong, nonatomic) BlogLikesView *likesView;
@end

CGFloat kAuthorInfoViewHeight = 85;
CGFloat kLikesViewHeight = 52;
UIEdgeInsets kContentInsets = (UIEdgeInsets){0, 20, 0, 20};

@implementation BlogContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.authorInfoView];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.likesView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.authorInfoView.timeLabel.text = @"9:16 AM";
    self.authorInfoView.nameLabel.text = @"Carol Rios";
    self.authorInfoView.avatorView.image = [UIImage imageNamed:@"Carol Rios"];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.authorInfoView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kAuthorInfoViewHeight);
    self.contentLabel.frame = CGRectMake(kContentInsets.left, kAuthorInfoViewHeight, CGRectGetWidth(self.view.bounds) - kContentInsets.left - kContentInsets.right, CGRectGetHeight(self.view.bounds) - kAuthorInfoViewHeight - 20 - kLikesViewHeight);
    self.likesView.frame = (CGRect){0, CGRectGetMaxY(self.contentLabel.frame) + 20, CGRectGetWidth(self.view.bounds), kLikesViewHeight};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)heightForFit{
    return kAuthorInfoViewHeight + self.contentLabel.textLayout.textBoundingSize.height + 20 + kLikesViewHeight;
}

#pragma mark - actions
- (void)showAllLikes:(id)sender{
    BlogLikesViewController *likesVC = [[BlogLikesViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:likesVC animated:YES];
}

- (void)updateContentLabel:(NSArray *)contents{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableAttributedString *content = [[NSMutableAttributedString alloc] init];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5;
        style.paragraphSpacing = 20;
        
        UIColor *textColor = [UIColor colorWithWhite:0.2 alpha:1.];
        
        UIFont *titleFont = [UIFont systemFontOfSize:26.];
        UIFont *contentFont = [UIFont systemFontOfSize:16.];
        UIFont *subtitleFont = [UIFont systemFontOfSize:20.];
        CGFloat labelWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - kContentInsets.left - kContentInsets.right;
        
        NSDictionary *titleAttrs = @{NSFontAttributeName:titleFont, NSForegroundColorAttributeName:textColor};
        NSDictionary *contentAttrs = @{NSFontAttributeName:contentFont, NSForegroundColorAttributeName:textColor};
        NSDictionary *subtitleAttr = @{NSFontAttributeName:subtitleFont, NSForegroundColorAttributeName:textColor};
        
        [contents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
                    __block ProductView *view;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        view = [[ProductView alloc] initWithFrame:(CGRect){0, 0, size}];
                        view.imageView.image = [UIImage imageNamed:attributes[@"imageName"]];
                        view.brandLabel.text = attributes[@"brand"];
                        view.nameLabel.text = attributes[@"name"];
                    });
                    
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
                    __block UIImageView *imageView;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        imageView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, size}];
                        imageView.layer.cornerRadius = 8.;
                        imageView.layer.masksToBounds = YES;
                        imageView.image = [UIImage imageNamed:attributes[@"imageName"]];
                    });
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
                __block UIView *separator;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    separator = [[UIView alloc] initWithFrame:(CGRect){0, 0, size}];
                    separator.backgroundColor = [UIColor colorWithWhite:0xE6/255. alpha:1.];
                });
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
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentLabel.textLayout = layout;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        });
    });
}

#pragma mark - getters and setters
- (void)setBlogURL:(NSURL *)blogURL{
    _blogURL = blogURL;
    __weak typeof(self) weakSelf = self;
    [BHXMLParser parseContentsOfURL:blogURL completion:^(NSArray *result) {
        __strong BlogContentViewController *strongSelf = weakSelf;
        [strongSelf updateContentLabel:result];
    }];
}

- (AuthorInfoView *)authorInfoView{
    if (!_authorInfoView) {
        _authorInfoView = [[AuthorInfoView alloc] init];
    }
    return _authorInfoView;
}

- (YYLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [YYLabel new];
        _contentLabel.displaysAsynchronously = YES;
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    }
    return _contentLabel;
}

- (BlogLikesView *)likesView{
    if (!_likesView) {
        _likesView = [[BlogLikesView alloc] init];
        [_likesView addTarget:self action:@selector(showAllLikes:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likesView;
}

@end

@implementation AuthorInfoView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.avatorView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.clockImageView];
        [self addSubview:self.timeLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.avatorView.frame = CGRectMake(20, 15, 50, 50);
    CGFloat lableOriginX = CGRectGetMaxX(self.avatorView.frame) + 10;
    self.nameLabel.frame = CGRectMake(lableOriginX , 20, CGRectGetWidth(self.bounds) - lableOriginX - 20, 18);
    self.clockImageView.frame = CGRectMake(lableOriginX, CGRectGetMaxY(self.nameLabel.frame)+6, 16, 16);
    
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.clockImageView.frame)+5,
                                      CGRectGetMinY(self.clockImageView.frame),
                                      CGRectGetWidth(self.nameLabel.frame) - CGRectGetMaxX( self.clockImageView.frame)-5, 16);
}


- (UIImageView *)avatorView{
    if (!_avatorView) {
        _avatorView = [[UIImageView alloc] init];
    }
    return _avatorView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor colorWithRed:0x9A/255. green:0x8E/255. blue:0xF3/255. alpha:1.];
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
        _timeLabel.font = [UIFont systemFontOfSize:12.];
        _timeLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.];
    }
    return _timeLabel;
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
