//
//  LoginViewController.h
//  BEO
//
//  Created by liuweiliang on 2017/9/11.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate;

@interface LoginViewController : UIViewController
@property (weak, nonatomic) id<LoginViewDelegate> delegate;
@end

@protocol LoginViewDelegate<NSObject>
- (void)loginViewDidGoBack:(LoginViewController *)loginViewController;
- (void)loginViewDidSignin:(LoginViewController *)loginViewController;
@end
