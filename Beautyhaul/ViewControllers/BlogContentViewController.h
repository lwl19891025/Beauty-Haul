//
//  BlogContentViewController.h
//  Beautyhaul
//
//  Created by liuweiliang on 2017/10/14.
//  Copyright © 2017年 beauty-haul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogContentViewController : UIViewController
@property (strong, nonatomic) NSURL * blogURL;
- (CGFloat)heightForFit;
@end
