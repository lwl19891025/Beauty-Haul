//
//  HomeViewController.m
//  BEO
//
//  Created by liuweiliang on 2017/9/11.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "HomeViewController.h"
#import "VideoViewController.h"
#import "BlogViewController.h"
#import "QAViewController.h"
#import "PollViewController.h"
#import "HomePollTableViewCell.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;
@end

static NSString *const kPollCellReuseIdentifier = @"pollCellReuseIdentifier";
static NSString *const kBlogCellReuseIdentifier = @"blogCellReuseIdentifier";
static NSString *const kVideoCellReuseIdentifier = @"videoCellReuseIdentifier";
static NSString *const kQACellReuseIdentifier = @"q&aCellReuseIdentifier";

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self generateDataSource];
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UINib *pollCell = [UINib nibWithNibName:NSStringFromClass([HomePollTableViewCell class]) bundle:nil];
    [self.tableView registerNib:pollCell forCellReuseIdentifier:kPollCellReuseIdentifier];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)generateDataSource{
    self.dataSource = @[@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPollCellReuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 310;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoViewController *video = [VideoViewController new];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:video animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
