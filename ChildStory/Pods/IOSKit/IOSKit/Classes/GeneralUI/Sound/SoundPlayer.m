//
//  IMMessageSoundPlayer.m
//  IMSDK
//
//  Created by armark.yan on 16/7/26.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import <IOSKit/SoundPlayer.h>

#import <IOSKit/IOSKit.h>

static BOOL isSound =  NO;

@interface SoundPlayer() {
    SystemSoundID soundIDShake;//系统声音的id 取值范围为：1000-2000
    SystemSoundID soundIDDefault;
    
    BOOL voiceOpen;
    BOOL shakeOpen;
    BOOL nightOpen;     // 夜间模式
}

@end

@implementation SoundPlayer

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        soundIDDefault = 0;
        soundIDShake = kSystemSoundID_Vibrate;//震动
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playSound) name:kSoundPlayerNoti object:nil];
    }
    return self;
}

// 声音、震动提示
- (void)playSound {
    //非防打扰时间
    if (![self isAvoidDisturbTime]) {
        if (voiceOpen && shakeOpen) {
            [self playSountWithType:IMSoundTypeShakeSoundAndShake];
        }else if (shakeOpen){
            [self playSountWithType:IMSoundTypeShake];
        }else if (voiceOpen) {
            [self playSountWithType:IMSoundTypeDefault];
        }
    }
}

- (void)setSoundVoiceOpen:(BOOL)isVoice ShakeOpen:(BOOL)isShake SoundFileName:(NSString *)soundName {
    
    [self initSystemSoundWithName:soundName];
    
    voiceOpen = isVoice;    //声音
    shakeOpen = isShake;    //振动
    
    nightOpen = NO;
}

- (BOOL)isAvoidDisturbTime {
    
    // 夜间防骚扰 23:00~8:00不提示声音
    if (nightOpen) {
        NSCalendar *calender = [NSCalendar currentCalendar];
        unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *currentComponents = [calender components:unitFlags fromDate:[NSDate date]];
        
        if (currentComponents.hour >= 23 || currentComponents.hour < 8) {
            return YES;
        }
    }
    return NO;
}

- (void)initSystemSoundWithName:(NSString *)soundName{
    
    NSString * bundlePath = nil;
    NSArray *interArr = [soundName componentsSeparatedByString:@"."];
    if ([interArr count] == 2) {
        bundlePath = [[NSBundle mainBundle] pathForResource:[interArr objectAtIndex:0] ofType:[interArr objectAtIndex:1]];
    }else if ([interArr count] == 1){
        bundlePath = [[NSBundle mainBundle] pathForResource:[interArr objectAtIndex:0] ofType:nil];
    }
    
    if (bundlePath) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:bundlePath]), &soundIDDefault);
        
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            soundIDDefault = 0;
        }
    }
}

- (void)playSountWithType:(IMSoundType)soundType {
    if (!isSound) {
        if (soundType == IMSoundTypeDefault) {
            AudioServicesPlaySystemSound(soundIDDefault);
        }else if (soundType == IMSoundTypeShakeSoundAndShake) {
            AudioServicesPlaySystemSound(soundIDDefault);
            AudioServicesPlaySystemSound(soundIDShake);
        }else{
            AudioServicesPlaySystemSound(soundIDShake);
        }
        
        isSound = YES;
        //设置间隔1s之后才能响
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isSound = NO;
        });
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AudioServicesDisposeSystemSoundID(soundIDDefault);
    AudioServicesDisposeSystemSoundID(soundIDShake);
}

@end
