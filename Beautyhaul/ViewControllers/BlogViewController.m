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

@interface BlogViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIImageView *avatorImageView;
@property (strong, nonatomic) UIScrollView *contentView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *clockImageView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) YYLabel *richTextLabel;
@property (strong, nonatomic) UIView *likesView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *commentView;

@property (strong, nonatomic) NSArray *blogContent;
@property (strong, nonatomic) NSArray *blogComments;

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray *viewsForRichText;
@end

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
    self.timeLabel.text = @"Carol Rios";
    self.nameLabel.text = @"9:16 AM";
    [self generateMockData];
}

- (void)generateMockData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"blog.xml" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    __weak typeof(self) weakSelf = self;
    [BHXMLParser parseContentsOfURL:fileURL completion:^(NSArray *result) {
        __strong BlogViewController *strongSelf = weakSelf;
        strongSelf.blogContent = result;
        [strongSelf updateContentView];
    }];
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
                imageView.layer.cornerRadius = 2.5;
                
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
                
                productView.layer.cornerRadius = 5.;
                productView.backgroundColor = [UIColor whiteColor];
                productView.layer.shadowOpacity = .15;
                productView.layer.shadowOffset = CGSizeMake(0, 0);
                productView.layer.shadowRadius = 5.;
                
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
                
//                NSString *imageUrlString = [[attributes objectForKey:@"uri"] stringByRemovingPercentEncoding];
//                NSURL *imageURL = [NSURL URLWithString:imageUrlString];
//                [[self.session dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                    UIImage *image = [UIImage imageWithData:data scale:2];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        imageView.image = image;
//                    });
//                }] resume];
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
    
//    self.richTextLabel.frame = (CGRect){0, 90, layout.textBoundingSize};
    self.richTextLabel.textLayout = layout;
    self.richTextLabel.attributedText = content;
    self.contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), layout.textBoundingSize.height+90+20);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.contentView.frame = self.view.bounds;
    self.avatorImageView.frame = CGRectMake(20, 20, 50, 50);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+10, 25, 200, 20);
    self.clockImageView.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+10, 49, 16, 16);
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.clockImageView.frame)+5, 49, 200, 16);
    self.richTextLabel.frame = (CGRect){0, 90, self.richTextLabel.textLayout.textBoundingSize};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share:(id)sender{
    
}

- (void)more:(id)sender{
    
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.blogComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const cellReuseID = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseID];
    }
    return cell;
}

#pragma mark - privates
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
#pragma mark - getters and setters

- (UIScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
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

@end
