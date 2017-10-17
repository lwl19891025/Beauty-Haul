//
//  CommentPreviewController.h
//  Fleeek
//
//  Created by liuweiliang on 2017/10/13.
//  Copyright © 2017年 fleeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentPreviewController : UIViewController
@property (assign, nonatomic) NSInteger maxCountToDisplay;
@property (assign, nonatomic) BOOL scrollEnabled;
@property (weak, nonatomic, readwrite) UIView *customHeadrView;
@property (strong, nonatomic) NSArray *comments;
- (CGFloat)heightForFit;
@end
