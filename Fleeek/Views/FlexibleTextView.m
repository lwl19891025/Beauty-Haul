//
//  FlexibleTextView.m
//  Fleeek
//
//  Created by liuweiliang on 2017/10/7.
//  Copyright © 2017年 fleeek. All rights reserved.
//

#import "FlexibleTextView.h"
@interface FlexibleTextView()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *leftContainer;
@property (weak, nonatomic) IBOutlet UIView *rightContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContainerWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContainerWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderTop;
@end

@implementation FlexibleTextView
@synthesize leftView = _leftView;
@synthesize rightView = _rightView;
@synthesize delegate = _delegate;
@synthesize text = _text;
@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize textAlignment = _textAlignment;
@synthesize selectedRange = _selectedRange;
@synthesize editable = _editable;
@synthesize selectable = _selectable;
@synthesize dataDetectorTypes = _dataDetectorTypes;
@synthesize allowsEditingTextAttributes = _allowsEditingTextAttributes;
@synthesize typingAttributes = _typingAttributes;
@synthesize clearsOnInsertion = _clearsOnInsertion;
@synthesize textContainerInset = _textContainerInset;
@synthesize linkTextAttributes = _linkTextAttributes;
@synthesize placeholder = _placeholder;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textView.delegate = self;
        self.placeholderLabel.font = self.textView.font;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.textContainer.lineFragmentPadding = 0;
    self.textContainerInset = UIEdgeInsetsZero;
    self.placeholderLabel.font = self.textView.font;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self setNeedsUpdateConstraints];
        [self updateFocusIfNeeded];
    }
}

- (CGFloat)heightThatFitsText{
    CGSize size = self.textView.bounds.size;
    CGSize fitSize = [self.textView sizeThatFits:CGSizeMake(size.width, CGFLOAT_MAX)];
    return fitSize.height + 12 + 12;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)scrollRangeToVisible:(NSRange)range{
    [self.textView scrollRangeToVisible:range];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.delegate textViewShouldBeginEditing:textView];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.delegate textViewShouldEndEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.delegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.delegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:textView];
    }
    self.placeholderLabel.hidden = textView.text.length > 0;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.delegate textViewDidChangeSelection:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if ([self.delegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:interaction:)]) {
        return [self.delegate textView:textView shouldInteractWithURL:URL inRange:characterRange interaction:interaction];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if ([self.delegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:interaction:)]) {
        return [self.delegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange interaction:interaction];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    if ([self.delegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
        return [self.delegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    if ([self.delegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]) {
        return [self.delegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}

- (void)setLeftView:(UIView *)leftView{
    [_leftView removeFromSuperview];
    _leftView = leftView;
    if (leftView) {
        [self.leftContainer addSubview:leftView];
        self.leftContainerWidth.constant = CGRectGetMaxX(leftView.frame);
    } else {
        self.leftContainerWidth.constant = 0;
    }
}

- (UIView *)leftView{
    return [[self.leftContainer subviews] firstObject];
}

- (void)setRightView:(UIView *)rightView{
    [_rightView removeFromSuperview];
    _rightView = rightView;
    if (rightView) {
        [self.rightContainer addSubview:rightView];
        self.rightContainerWidth.constant = CGRectGetMaxX(rightView.frame);
    } else {
        self.rightContainerWidth.constant = 0;
    }
}

- (UIView *)rightView{
    return [[self.rightContainer subviews] firstObject];
}

#pragma mark - getters and setters
- (void)setText:(NSString *)text{
    _text = text;
    self.placeholderLabel.hidden = text.length > 0;
    self.textView.text = text;
}

- (void)setFont:(UIFont *)font{
    _font = font;
    self.textView.font = font;
    self.placeholderLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [self.textView setTextColor:textColor];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    [self.textView setTextAlignment:textAlignment];
}

- (void)setSelectedRange:(NSRange)selectedRange{
    _selectedRange = selectedRange;
    [self.textView setSelectedRange:selectedRange];
}

- (void)setEditable:(BOOL)editable{
    _editable = editable;
    [self.textView setEditable:editable];
}

- (BOOL)isEditable{
    return _editable;
}

- (void)setSelectable:(BOOL)selectable{
    _selectable = selectable;
}

- (BOOL)isSelectable{
    return _selectable;
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes{
    _dataDetectorTypes = dataDetectorTypes;
    [self.textView setDataDetectorTypes:dataDetectorTypes];
}

- (void)setAllowsEditingTextAttributes:(BOOL)allowsEditingTextAttributes{
    _allowsEditingTextAttributes = allowsEditingTextAttributes;
    [self.textView setAllowsEditingTextAttributes:allowsEditingTextAttributes];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    self.placeholderLabel.hidden = attributedText.length > 0;
    [self.textView setAttributedText:attributedText];
}

- (NSAttributedString *)attributedText{
    return [self.textView attributedText];
}

- (void)setTypingAttributes:(NSDictionary<NSString *,id> *)typingAttributes{
    _typingAttributes = typingAttributes;
    [self.textView setTypingAttributes:typingAttributes];
}

- (void)setClearsOnInsertion:(BOOL)clearsOnInsertion{
    _clearsOnInsertion = clearsOnInsertion;
    [self.textView setClearsOnInsertion:clearsOnInsertion];
}

- (NSTextContainer *)textContainer{
    return [self.textView textContainer];
}

- (NSLayoutManager *)layoutManager{
    return [self.textView layoutManager];
}

- (NSTextStorage *)textStorage{
    return [self.textView textStorage];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset{
    _textContainerInset = textContainerInset;
    self.placeholderLeading.constant = textContainerInset.left+5;
    self.placeholderTop.constant = textContainerInset.top;
    [self.textView setTextContainerInset:textContainerInset];
}

- (void)setLinkTextAttributes:(NSDictionary<NSString *,id> *)linkTextAttributes{
    _linkTextAttributes = linkTextAttributes;
    [self.textView setLinkTextAttributes:linkTextAttributes];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

@end
