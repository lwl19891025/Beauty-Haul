//
//  ActionListView.h
//  Fleeek
//
//  Created by liuweiliang on 2017/10/6.
//  Copyright © 2017年 fleeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionListView;

@protocol ActionListViewDelegate <NSObject>
- (void)actionListView:(ActionListView *)view didSelectAtIndex:(NSInteger)index;
@end

@interface ActionListView : UIView
@property (weak, nonatomic) id<ActionListViewDelegate> delegate;

+ (ActionListView *)viewWithActionInfos:(NSArray *)actionInfos;
- (void)show;

@end
