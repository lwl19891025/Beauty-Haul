//
//  ThirdIntroductionViewController.h
//  Fleeek
//
//  Created by liuweiliang on 2017/9/16.
//  Copyright © 2017年 liuweiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^loginBlock)(void);

@interface ThirdIntroductionViewController : UIViewController
@property (copy, nonatomic) loginBlock loginWithFaceBook;
@property (copy, nonatomic) loginBlock loginWithEmail;
@end
