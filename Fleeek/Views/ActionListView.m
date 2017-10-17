//
//  ActionListView.m
//  Fleeek
//
//  Created by liuweiliang on 2017/10/6.
//  Copyright © 2017年 fleeek. All rights reserved.
//

#import "ActionListView.h"

@interface ActionListView()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIControl *backgroundView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *actionInfos;
@end

static CGFloat kTableViewWidth = 127.;
static CGFloat ActionCellHeight = 44.;
static NSString *const kActionCellReuseID = @"actionCell";

@implementation ActionListView

+ (ActionListView *)viewWithActionInfos:(NSArray *)actionInfos{
    ActionListView *view = [[ActionListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.actionInfos = actionInfos;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.tableView.frame = CGRectMake(frame.size.width - kTableViewWidth - 10, 65, kTableViewWidth, 0);
        self.backgroundView = [[UIControl alloc] initWithFrame:frame];
        [self.backgroundView addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backgroundView];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)didMoveToSuperview{
    if (self.superview) {
        [self displayShowAnimation];
    }
}

- (void)displayShowAnimation{
    CGRect endFrame = self.tableView.frame;
    endFrame.size.height = ActionCellHeight * self.actionInfos.count;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionLayoutSubviews animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.tableView.frame = endFrame;
    } completion:^(BOOL finished) {
        self.tableView.frame = endFrame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hide:(id)sender{
    [self dismiss:NULL];
}

- (void)dismiss:(void(^)(void))completionBlock{
    CGRect endFrame = self.tableView.frame;
    endFrame.size.height = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.tableView.frame = endFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    if (completionBlock){
        completionBlock();
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.actionInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kActionCellReuseID forIndexPath:indexPath];
    cell.textLabel.font = [UIFont fontWithName:@"PingFang SC" size:14.];
    NSDictionary *actionInfo = self.actionInfos[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:actionInfo[@"image"]];
    cell.textLabel.text = actionInfo[@"actionName"];
    cell.textLabel.textColor = actionInfo[@"textColor"] ? actionInfo[@"textColor"] : [UIColor colorWithWhite:0.2 alpha:1.];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) wself = self;
    [self dismiss:^{
        __strong ActionListView *sself = wself;
        if ([sself.delegate respondsToSelector:@selector(actionListView:didSelectAtIndex:)]) {
            [sself.delegate actionListView:sself didSelectAtIndex:indexPath.row];
        }
    }];
}

#pragma mark - getters and setters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.cornerRadius = 12.;
        _tableView.clipsToBounds = YES;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kActionCellReuseID];
    }
    return _tableView;
}
@end
