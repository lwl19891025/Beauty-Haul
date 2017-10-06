//
//  ActionListView.h
//  Beautyhaul
//
//  Created by liuweiliang on 2017/10/6.
//  Copyright © 2017年 beauty-haul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionListView : UIView
+ (ActionListView *)viewWithActionInfos:(NSArray *)actionInfos;
- (void)show;
@end
