//
//  BHTabBarController.m
//  Beauty-haul
//
//  Created by liuweiliang on 2017/9/11.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "BHTabBarController.h"
#import "HomeViewController.h"
#import "FindViewController.h"
#import "MessageViewController.h"
#import "NavigationViewController.h"
#import "ComposeViewController.h"
#import "ProfileViewController.h"

@interface BHTabBarController ()

@end

@implementation BHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NavigationViewController *homeNav = [[NavigationViewController alloc] initWithRootViewController:[HomeViewController new]];
     NavigationViewController *findNav = [[NavigationViewController alloc] initWithRootViewController:[FindViewController new]];
    NavigationViewController *compose = [[NavigationViewController alloc] initWithRootViewController:[ComposeViewController new]];
    NavigationViewController *message = [[NavigationViewController alloc] initWithRootViewController:[MessageViewController new]];
    NavigationViewController *profile = [[NavigationViewController alloc] initWithRootViewController:[ProfileViewController new]];
    
    self.viewControllers = @[homeNav, findNav, compose, message, profile];
    [self.tabBar setBarTintColor:[UIColor colorWithWhite:36./255 alpha:1.]];
    [self.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                obj.image = [UIImage imageNamed:@"Home"];
                obj.selectedImage = [UIImage imageNamed:@"Home"];
                obj.title = @"Home";
                break;
            case 1:
                obj.image = [UIImage imageNamed:@"Find"];
                obj.selectedImage = [UIImage imageNamed:@"Find"];
                obj.title = @"Find";
                break;
            case 2:
                obj.image = [UIImage imageNamed:@"Compose"];
                obj.selectedImage = [UIImage imageNamed:@"Compose"];
                obj.title = @"Compose";
                break;
            case 3:
                obj.image = [UIImage imageNamed:@"Message"];
                obj.selectedImage = [UIImage imageNamed:@"Message"];
                obj.title = @"Message";
                break;
            case 4:
                obj.image = [UIImage imageNamed:@"Profile"];
                obj.selectedImage = [UIImage imageNamed:@"Profile"];
                obj.title = @"Profile";
                break;
            default:
                break;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
