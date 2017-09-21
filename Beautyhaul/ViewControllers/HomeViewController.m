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
#import "HomeBlogTableViewCell.h"
#import "HomeVideoTableViewCell.h"
#import "HomeQATableViewCell.h"

typedef NS_ENUM(NSUInteger, ContentType){
    VideoContentType,
    BlogContentType,
    PollContentType,
    QAContentType,
};

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
    self.title = @"Home";
    [self generateDataSource];
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UINib *pollCell = [UINib nibWithNibName:NSStringFromClass([HomePollTableViewCell class]) bundle:nil];
    [self.tableView registerNib:pollCell forCellReuseIdentifier:kPollCellReuseIdentifier];
    
    UINib *blogCell = [UINib nibWithNibName:NSStringFromClass([HomeBlogTableViewCell class]) bundle:nil];
    [self.tableView registerNib:blogCell forCellReuseIdentifier:kBlogCellReuseIdentifier];
    
    UINib *videoCell = [UINib nibWithNibName:NSStringFromClass([HomeVideoTableViewCell class]) bundle:nil];
    [self.tableView registerNib:videoCell forCellReuseIdentifier:kVideoCellReuseIdentifier];
    
    UINib *qaCell = [UINib nibWithNibName:NSStringFromClass([HomeQATableViewCell class]) bundle:nil];
    [self.tableView registerNib:qaCell forCellReuseIdentifier:kQACellReuseIdentifier];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset =  UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
    self.tableView.contentOffset = CGPointMake(0, -self.topLayoutGuide.length);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)generateDataSource{
    self.dataSource = @[@{@"type":@(PollContentType), @"name":@"Jessy", @"avator":@"avator1"},
                        @{@"type":@(VideoContentType), @"name":@"David",@"avator":@"avator4"},
                        @{@"type":@(QAContentType), @"name":@"Tom Carry",@"avator":@"avator2"},
                        @{@"type":@(PollContentType), @"name":@"Jimmy Henry",@"avator":@"avator1"},
                        @{@"type":@(BlogContentType), @"name":@"Nikulas Kech",@"avator":@"avator3"},
                        @{@"type":@(VideoContentType), @"name":@"Jessy Ksea",@"avator":@"avator2"},
                        @{@"type":@(BlogContentType), @"name":@"Jessic Hsefw",@"avator":@"avator4"},
                        @{@"type":@(QAContentType), @"name":@"Nosfe Gwnefa",@"avator":@"avator1"},
                        @{@"type":@(VideoContentType), @"name":@"Tong Xiao Rong",@"avator":@"avator3"},
                        @{@"type":@(VideoContentType), @"name":@"Shang Guan Yun Yan",@"avator":@"avator1"},
                        @{@"type":@(PollContentType), @"name":@"TaTa Jue less",@"avator":@"avator2"},
                        @{@"type":@(BlogContentType), @"name":@"Hahahahah",@"avator":@"avator4"},
                        @{@"type":@(QAContentType), @"name":@"Shi zai bu zhi jiao sha",@"avator":@"avator3"},
                        @{@"type":@(VideoContentType), @"name":@"Qi ming zhen nan",@"avator":@"avator1"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID ;
    ContentType type = [[self.dataSource[indexPath.row] objectForKey:@"type"] integerValue];
    if (type == BlogContentType) {
        reuseID = kBlogCellReuseIdentifier;
    } else if (type == PollContentType){
        reuseID = kPollCellReuseIdentifier;
    } else if (type == VideoContentType){
        reuseID = kVideoCellReuseIdentifier;
    } else {
        reuseID = kQACellReuseIdentifier;
    }
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.nameLabel.text = [self.dataSource[indexPath.row] objectForKey:@"name"];
    cell.avator.image = [UIImage imageNamed:[self.dataSource[indexPath.row] objectForKey:@"avator"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContentType type = [[self.dataSource[indexPath.row] objectForKey:@"type"] integerValue];
    if (type == BlogContentType) {
        return 338;
    } else if (type == PollContentType){
        return 310;
    } else if (type == VideoContentType){
        return 203;
    }
    return 216;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoViewController *video = [VideoViewController new];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:video animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:244./255 green:244./255 blue:248./255 alpha:1.];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
