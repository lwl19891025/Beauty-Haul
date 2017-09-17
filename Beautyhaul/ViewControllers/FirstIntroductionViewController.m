//
//  FirstIntroductionViewController.m
//  BEO
//
//  Created by liuweiliang on 2017/9/12.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "FirstIntroductionViewController.h"

@interface FirstIntroductionViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation FirstIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"introduction1"]];
    [self.view addSubview:self.imageView];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.imageView.frame = self.view.bounds;
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
