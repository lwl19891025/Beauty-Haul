//
//  BHXMLParser.h
//  Fleeek
//
//  Created by liuweiliang on 2017/10/2.
//  Copyright © 2017年 fleeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHXMLParser : NSObject
+ (void)parseContentsOfURL:(NSURL *)url completion:(void(^)(NSArray *))completion;
@end
