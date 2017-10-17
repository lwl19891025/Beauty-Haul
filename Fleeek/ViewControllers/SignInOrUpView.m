//
//  SignInOrUpView.m
//  Fleeek
//
//  Created by liuweiliang on 2017/9/16.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import "SignInOrUpView.h"

@interface SignInOrUpView()
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *codeTextFields;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@end

@implementation SignInOrUpView
- (void)awakeFromNib{
    [super awakeFromNib];
    UILabel *leftView = [[UILabel alloc] init];
    leftView.text = @"@";
    leftView.font = [UIFont systemFontOfSize:14];
    [leftView sizeToFit];
    self.nicknameTextField.leftView = leftView;
}

- (NSString *)code{
    return @"";
}

- (NSString *)nickname{
    return self.nicknameTextField.text;
}

@end
