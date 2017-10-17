//
//  PageMenuView.h
//  Fleeek
//
//  Created by liuweiliang on 2017/10/14.
//  Copyright © 2017年 fleeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageMenuView;

@protocol PageMenuViewDelegate<NSObject>
- (void)pageMenuView:(PageMenuView *)menuView didSelectedAtIndex:(NSInteger)index;
@end

@interface PageMenuView : UIView
@property (strong, nonatomic) NSArray<NSString *> *menus;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) id<PageMenuViewDelegate> delegate;
@end
