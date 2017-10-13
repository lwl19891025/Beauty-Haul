//
//  CommentPreviewController.h
//  Beautyhaul
//
//  Created by liuweiliang on 2017/10/13.
//  Copyright © 2017年 beauty-haul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentPreviewController : UIViewController
@property (assign, nonatomic) NSInteger maxCountToDisplay;
@property (assign, nonatomic) BOOL srollEnabled;
@property (weak, nonatomic, readwrite) UIView *customHeadrView;
@property (strong, nonatomic) NSArray *comments;
- (CGFloat)heightForFit;
@end
