

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <IOSKit/Circle.h>

#define kMax_Distance 75

@interface MetaBallItem : NSObject

@property(nonatomic, weak, readonly) UIView *view;

@property(nonatomic) Circle *centerCircle;

@property(nonatomic) Circle *touchCircle;

@property(nonatomic) float maxDistance; // 最大距离

@property(nonatomic) UIColor *color;    // 颜色

- (instancetype)initWithView:(UIView *)view;

@end
