//
//  BlogLikesViewController.m
//  Fleeek
//
//  Created by liuweiliang on 2017/10/6.
//  Copyright © 2017年 fleeek. All rights reserved.
//

#import "BlogLikesViewController.h"
//@interface BlogLikesTableViewCell :UITableViewCell
//
//@end

@interface BlogLikesViewController ()
@property (strong, nonatomic) NSArray *likes;
@end

static NSString *const kBlogLikesCellReuseID = @"kBlogLikesCell";

@implementation BlogLikesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Likes";
    self.likes = @[@"Carol Rios",
                   @"Chloe ward",
                   @"Melxoxo",
                   @"Misty James",
                   @"Kylie McCool",
                   @"Brenda Mann"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kBlogLikesCellReuseID];
    self.tableView.backgroundColor = [UIColor colorWithWhite:248./255 alpha:1.];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button"] style:UIBarButtonItemStylePlain target:self action:@selector(pop:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    self.tableView.tableFooterView = [UIView new];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.likes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBlogLikesCellReuseID forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:self.likes[indexPath.row]];
    cell.textLabel.text = self.likes[indexPath.row];
    cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
