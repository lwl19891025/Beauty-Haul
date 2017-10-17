//
//  BlogContentViewController.h
//  Fleeek
//
//  Created by liuweiliang on 2017/10/14.
//  Copyright © 2017年 fleeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogContentViewController : UIViewController
@property (strong, nonatomic) NSURL * blogURL;
/**
 when content size.height larger than view frame height , if showMoreButton is YES ,then show expand button; default is NO;
 */
@property (assign, nonatomic) BOOL showMoreButton;
@property (copy, nonatomic) void(^finishLayoutBlock)(void);
@property (copy, nonatomic) void(^expandContentBlock)(CGFloat heightForFit);
- (CGFloat)heightForFit;
@end
