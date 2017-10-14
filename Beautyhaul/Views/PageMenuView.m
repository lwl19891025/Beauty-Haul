//
//  PageMenuView.m
//  Beautyhaul
//
//  Created by liuweiliang on 2017/10/14.
//  Copyright © 2017年 beauty-haul. All rights reserved.
//

#import "PageMenuView.h"

@interface PageMenuView()
@property (strong, nonatomic) NSArray<UIButton *> *menuButtons;
@property (strong, nonatomic) UIView *selectedIndicator;
@end

@implementation PageMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.selectedIndicator];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat itemWidth = CGRectGetWidth(self.bounds)/self.menuButtons.count;
    CGFloat itemHeight = CGRectGetHeight(self.bounds) - 2;
    [self.menuButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.frame = CGRectMake(idx * itemWidth, 0, itemWidth, itemHeight);
    }];
    self.selectedIndicator.frame = CGRectMake(0, itemHeight, itemWidth, 2);
}


- (UIButton *)createButtonForMenu:(NSString *)title{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:0.6 alpha:1.] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0x9A/255. green:0x8E/255. blue:0xF3/255. alpha:1.] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    return button;
}

- (void)buttonClick:(UIButton *)button{
    [self.menuButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = (obj == button);
    }];
    NSInteger index = [self.menuButtons indexOfObject:button];
    CGRect frame = self.selectedIndicator.frame;
    frame.origin.x = index * CGRectGetWidth(frame);
    [UIView animateWithDuration:0.25 animations:^{
        self.selectedIndicator.frame = frame;
    }];
}

- (UIView *)selectedIndicator{
    if (!_selectedIndicator) {
        _selectedIndicator = [[UIView alloc] init];
        _selectedIndicator.backgroundColor = [UIColor colorWithRed:0x9A/255. green:0x8E/255. blue:0xF3/255. alpha:1.];
    }
    return _selectedIndicator;
}

- (void)setMenuButtons:(NSArray<UIButton *> *)menuButtons{
    [_menuButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _menuButtons = menuButtons;
    [_menuButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:button];
    }];
}

- (void)setMenus:(NSArray<NSString *> *)menus{
    _menus = menus;
    __block NSMutableArray *buttons = [NSMutableArray new];
    [menus enumerateObjectsUsingBlock:^(NSString * _Nonnull text, NSUInteger idx, BOOL * _Nonnull stop) {
        [buttons addObject:[self createButtonForMenu:text]];
    }];
    self.menuButtons = buttons;
    [self.menuButtons.firstObject sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
