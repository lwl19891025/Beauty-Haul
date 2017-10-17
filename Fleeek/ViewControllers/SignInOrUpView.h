//
//  SignInOrUpView.h
//  Fleeek
//
//  Created by liuweiliang on 2017/9/16.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInOrUpView : UIView
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *nicknameView;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

- (NSString *)code;
- (NSString *)nickname;

@end
