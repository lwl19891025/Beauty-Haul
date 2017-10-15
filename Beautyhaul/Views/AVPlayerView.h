//
//  AVPlayerView.h
//  Beautyhaul
//
//  Created by liuweiliang on 2017/10/9.
//  Copyright © 2017年 beauty-haul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerView : UIView
/**
 return current player.
 */
@property (weak, nonatomic, readonly) AVPlayer *player;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) NSArray<NSURL *> *videoURLs;

- (void)play;
- (void)pause;

@end
