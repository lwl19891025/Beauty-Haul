//
//  ComposeViewController.m
//  Fleeek
//
//  Created by liuweiliang on 2017/9/14.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "ComposeViewController.h"
#import "BlogEditViewController.h"

@interface ComposeViewController ()
@property (strong, nonatomic) UIButton *postBlogButton;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Compose";
    [self.view addSubview:self.postBlogButton];
    // Do any additional setup after loading the view.
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.postBlogButton.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postBlog:(id)sender{
    [self.navigationController pushViewController:[BlogEditViewController new] animated:YES];
}


- (UIButton *)postBlogButton{
    if (!_postBlogButton) {
        _postBlogButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_postBlogButton setFrame:CGRectMake(0, 0, 100, 30)];
        [_postBlogButton setTitle:@"Post A Blog" forState:UIControlStateNormal];
        [_postBlogButton addTarget:self action:@selector(postBlog:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBlogButton;
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
