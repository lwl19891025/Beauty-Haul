//
//  IntroductionViewController.h
//  Fleeek
//
//  Created by liuweiliang on 2017/9/11.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IntroductionViewController;

@protocol IntroductionViewDelegate <NSObject>
@optional
- (void)skipIntroduction:(IntroductionViewController *)vc;
- (void)continueLoginWithEmail:(IntroductionViewController *)vc;
- (void)continueLoginWithFacebook:(IntroductionViewController *)vc;

@end

@interface IntroductionViewController : UIViewController
@property (weak, nonatomic) id<IntroductionViewDelegate> delegate;
@end
