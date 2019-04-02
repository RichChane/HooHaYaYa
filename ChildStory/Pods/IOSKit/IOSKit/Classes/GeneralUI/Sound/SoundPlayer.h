//
//  IMMessageSoundPlayer.h
//  IMSDK
//
//  Created by armark.yan on 16/7/26.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>

static const NSString * _Nullable kSoundPlayerNoti = @"kSoundPlayerNoti";           // 支持通知播放语音

typedef NS_ENUM(NSUInteger, IMSoundType) {
    IMSoundTypeDefault,
    IMSoundTypeShakeSoundAndShake,
    IMSoundTypeShake
};

@interface SoundPlayer : NSObject

+ (instancetype)sharedInstance;

- (void)setSoundVoiceOpen:(BOOL)isVoice ShakeOpen:(BOOL)isShake SoundFileName:(NSString *)soundName;     // 声音重置

- (void)playSound;      // 声音、震动提示


@end
