//
//  AVPlayerView.m
//  Beautyhaul
//
//  Created by liuweiliang on 2017/10/9.
//  Copyright © 2017年 beauty-haul. All rights reserved.
//

#import "AVPlayerView.h"


@implementation AVPlayerView
+ (Class)layerClass{
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)playerLayer{
    return (AVPlayerLayer *)self.layer;
}

- (void)setVideoURL:(NSURL *)videoURL{
    _videoURL = videoURL;
    [self.player pause];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
