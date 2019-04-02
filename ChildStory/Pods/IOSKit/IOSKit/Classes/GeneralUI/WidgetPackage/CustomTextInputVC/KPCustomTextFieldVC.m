//
//  KPCustomTextFieldVC.m
//  kp
//
//  Created by gzkp on 2018/8/8.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "KPCustomTextFieldVC.h"
#import "GeneralConfig.h"
#import <KPFoundation/KPFoundation.h>
#import <GMUtils+HUD.h>
#import "KPTextField.h"

@interface KPCustomTextFieldVC ()

@property (nonatomic,strong) KPTextField *textField;

@property (nonatomic,strong) NSString *placeholder;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,assign) NSInteger textMaxLength;

@property (nonatomic, copy) NSString * titleStr;
@end

@implementation KPCustomTextFieldVC

- (instancetype)initWithTitle:(NSString *)title AndPlaceholder:(NSString *)placeholder AndText:(NSString *)text AndTextMaxLength:(NSInteger)textMaxLength
{
    self = [super init];
    if (self) {
        
        _titleStr = title;
        self.placeholder = placeholder;
        self.text = text;
        
        _textMaxLength = textMaxLength;
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customTitleStr = _titleStr;
    [self addLeftBarButtonItem:ImageName(@"back")];
    [self addRightBarButtonItem:ML(@"保存")];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10 + GC.navBarHeight+GC.topBarNowHeight, self.view.frame.size.width, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    KPTextField *textField = [[KPTextField alloc]initWithFrame:CGRectMake(15, 0, bgView.frame.size.width-15*2, bgView.frame.size.height)];
    [bgView addSubview:textField];
    textField.text = self.text;
    textField.keyboardType = self.keyboardType;
    textField.placeholder = self.placeholder;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textField = textField;
    if (self.textFieldDelegate) {
        textField.delegate = self.textFieldDelegate;
    }
    
    [textField becomeFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (_textMaxLength) {
        if (textField.text.length > _textMaxLength) {
            textField.text = [textField.text substringToIndex:_textMaxLength];
            [textField.undoManager removeAllActions];
            
            [GMUtils showQuickTipWithText:ML(@"输入超过长度限制")];
        }
    }
    
}

#pragma mark - action
- (void)leftBarButtonItemClicked:(UIBarButtonItem *)barButtonItem {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBarButtonItemClicked:(UIBarButtonItem *)barButtonItem {
    
    if (self.textInputBlock) {
        self.textInputBlock(_textField.text);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
