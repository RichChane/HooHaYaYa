//
//  PhotoMainListController.h
//  Expecta
//
//  Created by zhang yyuan on 2018/7/5.
//

#import <IOSKit/GeneralViewController.h>
#import <IOSKit/IOSKit.h>
@interface PhotoMainListController : GeneralViewController

// 区分单选还是多选  默认多选
@property (nonatomic, assign) PhotoSelectType selectPhotoType;

@end
