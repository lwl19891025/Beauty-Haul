//
//  BlogViewController.m
//  BEO
//
//  Created by liuweiliang on 2017/9/14.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "BlogViewController.h"

@interface BlogViewController ()
@property (strong, nonatomic) UIImageView *avatorImageView;
@property (strong, nonatomic) UIScrollView *contentView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *clockImageView;
@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation BlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"BeautyHaul’s";
    [self setupNavigationItem];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.avatorImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.clockImageView];
    [self.contentView addSubview:self.timeLabel];
    
    self.timeLabel.text = @"Carol Rios";
    self.nameLabel.text = @"9:16 AM";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
