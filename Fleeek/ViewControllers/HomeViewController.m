//
//  HomeViewController.m
//  Fleeek
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
@property (strong, nonatomic) NSDictionary *detailClass;
@end

//static NSString *const kPollCellReuseIdentifier = @"pollCellReuseIdentifier";
//static NSString *const kBlogCellReuseIdentifier = @"blogCellReuseIdentifier";
static NSString *const kVideoCellReuseIdentifier = @"videoCellReuseIdentifier";
//static NSString *const kQACellReuseIdentifier = @"q&aCellReuseIdentifier";

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    [self generateDataSource];
    [self.view addSubview:self.tableView];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    UINib *pollCell = [UINib nibWithNibName:NSStringFromClass([HomePollTableViewCell class]) bundle:nil];
    //    [self.tableView registerNib:pollCell forCellReuseIdentifier:kPollCellReuseIdentifier];
    //
    //    UINib *blogCell = [UINib nibWithNibName:NSStringFromClass([HomeBlogTableViewCell class]) bundle:nil];
    //    [self.tableView registerNib:blogCell forCellReuseIdentifier:kBlogCellReuseIdentifier];
    
    UINib *videoCell = [UINib nibWithNibName:NSStringFromClass([HomeVideoTableViewCell class]) bundle:nil];
    [self.tableView registerNib:videoCell forCellReuseIdentifier:kVideoCellReuseIdentifier];
    
    //    UINib *qaCell = [UINib nibWithNibName:NSStringFromClass([HomeQATableViewCell class]) bundle:nil];
    //    [self.tableView registerNib:qaCell forCellReuseIdentifier:kQACellReuseIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)generateDataSource{
    self.dataSource = @[@{@"name":@"Carol Rios",@"avator":@"Carol Rios", @"video":@"video1",@"content":@"It was that time of the year again that I hated. My birthday."},
                        @{@"name":@"Carol Rios",@"avator":@"Carol Rios", @"video":@"video2",@"content":@"I probably shouldn’t have said any of those words because what followed was an onslaught of abuse, some of the best advice I’ve been given and a ten-minute hack to take back control of your life."},
                        @{@"name":@"Carol Rios",@"avator":@"Carol Rios", @"video":@"video2",@"content":@"Everyone reading this post has a big dream that they’ve seen others achieve"},
                        @{@"name":@"Carol Rios",@"avator":@"Carol Rios", @"video":@"video1",@"content":@"My mentor took me out for lunch at my favorite vegetarian restaurant that doubles as a Buddhist temple"},
                        @{@"name":@"Carol Rios",@"avator":@"Carol Rios", @"video":@"video2",@"content":@"You’ve probably felt at one time or another like you’re not quite sure how to follow in the steps of the greats who have done what you hope to do."},
                        @{@"name":@"Jessy Ksea",@"avator":@"Carol Rios", @"video":@"video2",@"content":@"My mentor took me out for lunch at my favorite vegetarian restaurant that doubles as a Buddhist temple"},
                        @{@"name":@"Carol Rios",@"avator":@"Carol Rios", @"video":@"video1",@"content":@"My challenge to you"},
                        @{@"name":@"Carol Rios",@"avator":@"Carol Rios", @"video":@"video2",@"content":@"My mentor took me out for lunch at my favorite vegetarian restaurant that doubles as a Buddhist temple"},
                        @{@"name":@"Carol Rios",@"avator":@"Carol Rios", @"video":@"video1",@"content":@"How To Apply Eyeshadow Perfectly, here are my hacks."},
                        @{@"name":@"Shang Guan",@"avator":@"Carol Rios", @"video":@"video2",@"content":@"My mentor took me out for lunch at my favorite vegetarian restaurant that doubles as a Buddhist temple"}];
    //    self.detailClass = @{@(QAContentType)   : NSStringFromClass([QAViewController class]),
    //                         @(PollContentType) : NSStringFromClass([PollViewController class]),
    //                         @(VideoContentType): NSStringFromClass([VideoViewController class]),
    //                         @(BlogContentType) : NSStringFromClass([BlogViewController class])};
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kVideoCellReuseIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = [self.dataSource[indexPath.row] objectForKey:@"name"];
    cell.avator.image = [UIImage imageNamed:[self.dataSource[indexPath.row] objectForKey:@"avator"]];
    cell.demoImage.image = [UIImage imageNamed:[self.dataSource[indexPath.row] objectForKey:@"video"]];
    cell.contentLabel.text = [self.dataSource[indexPath.row] objectForKey:@"content"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 205 + CGRectGetWidth([UIScreen mainScreen].bounds) * 41/75;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoViewController *videoVC = [VideoViewController new];
    [self.navigationController pushViewController:videoVC animated:YES];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //        UIGraphicsBeginImageContextWithOptions(cell.contentView.bounds.size, cell.contentView.opaque, 0.0f);
    //        [cell.contentView drawViewHierarchyInRect:cell.contentView.bounds afterScreenUpdates:NO];
    //        UIImage *snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext();
    //        UIGraphicsEndImageContext();
    //        video.image = snapshotImageFromMyView;
    //    });
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:248./255 green:248./255 blue:248./255 alpha:1.];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
