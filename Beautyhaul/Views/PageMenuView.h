//
//  PageMenuView.h
//  Beautyhaul
//
//  Created by liuweiliang on 2017/10/14.
//  Copyright © 2017年 beauty-haul. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageMenuView;

@protocol PageMenuViewDelegate<NSObject>

@end

@interface PageMenuView : UIView
@property (strong, nonatomic) NSArray<NSString *> *menus;
@end
