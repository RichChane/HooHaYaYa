//
//  Created by Matt Greenfield on 24/05/12
//  Copyright (c) 2012 Big Paua. All rights reserved
//  http://bigpaua.com/
//

#import <Foundation/Foundation.h>


typedef void(^ClickView)(void);

@interface MGScrollView : UIScrollView

@property (nonatomic, retain) NSMutableArray *boxes;
@property (nonatomic, assign) BOOL isNeedRefresh;
@property (nonatomic, copy) ClickView clickView;


- (void)drawBoxesWithSpeed:(NSTimeInterval)speed;
- (void)updateContentSize;
- (void)snapToNearestBox;
- (void)tapScreen;

@end
