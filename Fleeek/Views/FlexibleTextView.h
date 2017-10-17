//
//  FlexibleTextView.h
//  Fleeek
//
//  Created by liuweiliang on 2017/10/7.
//  Copyright © 2017年 fleeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlexibleTextView : UIView

@property(nonatomic, weak) id<UITextViewDelegate> delegate;

@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic) NSTextAlignment textAlignment;
@property(nonatomic) NSRange selectedRange;
@property(nonatomic, getter=isEditable) BOOL editable;
@property(nonatomic, getter=isSelectable) BOOL selectable;
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes;

@property(nonatomic) BOOL allowsEditingTextAttributes;
@property(nonatomic, copy) NSDictionary<NSString *, id> *typingAttributes;

@property(nonatomic) BOOL clearsOnInsertion;
@property(nonatomic, assign) UIEdgeInsets textContainerInset;
@property(nonatomic, copy) NSDictionary<NSString *, id> *linkTextAttributes;
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, strong) UIView *leftView;
@property(nonatomic, strong) UIView *rightView;

- (NSTextContainer *)textContainer;
- (NSLayoutManager *)layoutManager;
- (NSTextStorage *)textStorage;

- (void)scrollRangeToVisible:(NSRange)range;

- (void)setAttributedText:(NSAttributedString *)attributedText;
- (NSAttributedString *)attributedText;

- (CGFloat)heightThatFitsText;
@end
