//
//  PasswordAlertView.m
//  自定义密码输入框
//
//  Created by ZXW on 2016/12/15.
//  Copyright © 2016年 ZXW. All rights reserved.
//

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#import "PasswordAlertView.h"

@interface PasswordAlertView ()<UITextFieldDelegate>
@property (nonatomic,assign) PasswordAlertViewType currentType;
@property (nonatomic,strong) UIView         *bgView;
@property (nonatomic,strong) UIView         *inputBgView;
@property (nonatomic,strong) UITextField    *inputTextFiled; //输入框
@property (nonatomic,strong) UIButton       *confirmBtn;

@end

@implementation PasswordAlertView



- (instancetype)initWithType:(PasswordAlertViewType)type
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        self.inputTextFiled = [[UITextField alloc]init];
        self.inputTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        self.inputTextFiled.delegate = self;
        [self addSubview:self.inputTextFiled];
        self.inputTextFiled.hidden = YES;
        [self.inputTextFiled addTarget:self action:@selector(inputTextChanged:) forControlEvents:UIControlEventEditingChanged];
        _currentType = type;
        switch (type) {
            case PasswordAlertViewType_default:
            {
                [self setupWithPasswordAlertViewType_default];
            }
                break;
                
            case PasswordAlertViewType_sheet:
            {
                [self setupithPasswordAlertViewType_sheet];
                
            }
                break;
            default:
                break;
        }
    }
    return self;
}

-(void)setupWithPasswordAlertViewType_default{
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(20, self.center.y-100, ScreenWidth-40, 200)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 15;
    self.bgView.layer.masksToBounds = YES;
    [self addSubview:self.bgView];
    
    //标题
    self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.bgView.frame.size.width-80, 50)];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable.font = [UIFont systemFontOfSize:19];
    self.titleLable.text = @"请输入密码";
    self.titleLable.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.titleLable];
    
    //取消按钮
    UIButton *cancleBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(CGRectGetWidth(self.bgView.frame)-35, 5, 30, 30);
    cancleBtn.backgroundColor = [UIColor clearColor];
    [cancleBtn setImage:[UIImage imageNamed:@"xxx"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:cancleBtn];
    
    //分割线
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLable.frame), self.bgView.frame.size.width,1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:line1];
    
    //开始绘制输入框(6个格子40X45)
    _inputBgView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bgView.frame)/2-135, CGRectGetMaxY(line1.frame)+25, 270, 40)];
    _inputBgView.backgroundColor = [UIColor whiteColor];
    _inputBgView.layer.borderWidth = 1.0;
    _inputBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.bgView addSubview:_inputBgView];
    //线框
    for (int i = 0; i<5; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake((i+1)*45, 0, 1, 40)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_inputBgView addSubview:line];
    }
    //黑色圆点
    for (int i = 0; i<6; i++) {
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*45, 0, 45, 40)];
        imgView.tag = 100+i;
        imgView.hidden = YES;
        [_inputBgView addSubview:imgView];
        
        UIImageView *smallImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12.5, 10, 20, 20)];
        smallImageView.image = [UIImage imageNamed:@"passwordIcon"];
        [imgView addSubview:smallImageView];
    }
    
    //下面的提示文字
    self.tipsLalbe = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_inputBgView.frame), CGRectGetMaxY(_inputBgView.frame)+7.5, 240, 15)];
    self.tipsLalbe.font = [UIFont systemFontOfSize:14];
    self.tipsLalbe.textColor = [UIColor redColor];
    self.tipsLalbe.text = @"密码不正确！";
    self.tipsLalbe.hidden = YES;
    [self.bgView addSubview:self.tipsLalbe];
    
    //确定按钮
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.frame = CGRectMake(30, CGRectGetMaxY(self.tipsLalbe.frame)+5, CGRectGetWidth(self.bgView.frame)-60, 40);
    self.confirmBtn.userInteractionEnabled = NO;
    self.confirmBtn.backgroundColor = [UIColor grayColor];
    self.confirmBtn.layer.cornerRadius = 10;
    self.confirmBtn.layer.masksToBounds = YES;
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(cofirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.confirmBtn];
}

-(void)setupithPasswordAlertViewType_sheet{
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden) name:UIKeyboardWillHideNotification object:nil];

    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 200)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    //标题
    self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.bgView.frame.size.width-80, 50)];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable.font = [UIFont systemFontOfSize:19];
    self.titleLable.text = @"请输入密码";
    self.titleLable.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.titleLable];
    
    //取消按钮
    UIButton *cancleBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(5, 5, 30, 30);
    cancleBtn.backgroundColor = [UIColor clearColor];
    [cancleBtn setImage:[UIImage imageNamed:@"xxx"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:cancleBtn];
    
    //分割线
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLable.frame), self.bgView.frame.size.width,1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:line1];
    
    //开始绘制输入框(6个格子40X45)
    _inputBgView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bgView.frame)/2-135, CGRectGetMaxY(line1.frame)+25, 270, 40)];
    _inputBgView.backgroundColor = [UIColor whiteColor];
    _inputBgView.layer.borderWidth = 1.0;
    _inputBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.bgView addSubview:_inputBgView];
    //线框
    for (int i = 0; i<5; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake((i+1)*45, 0, 1, 40)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_inputBgView addSubview:line];
    }
    //黑色圆点
    for (int i = 0; i<6; i++) {
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*45, 0, 45, 40)];
        imgView.tag = 100+i;
        imgView.hidden = YES;
        [_inputBgView addSubview:imgView];
        
        UIImageView *smallImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12.5, 10, 20, 20)];
        smallImageView.image = [UIImage imageNamed:@"passwordIcon"];
        [imgView addSubview:smallImageView];
    }
    
    //下面的提示文字
    self.tipsLalbe = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_inputBgView.frame), CGRectGetMaxY(_inputBgView.frame)+7.5, 240, 15)];
    self.tipsLalbe.font = [UIFont systemFontOfSize:14];
    self.tipsLalbe.textColor = [UIColor redColor];
    self.tipsLalbe.text = @"密码不正确！";
    self.tipsLalbe.hidden = YES;
    [self.bgView addSubview:self.tipsLalbe];
    
    //忘记密码按钮
    UIButton *forgetPWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPWBtn.frame = CGRectMake(CGRectGetMaxX(self.inputBgView.frame)-70, CGRectGetMaxY(self.tipsLalbe.frame), 80, 30);
    [forgetPWBtn addTarget:self action:@selector(forgetPWBtnClick) forControlEvents:UIControlEventTouchUpInside];
    forgetPWBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetPWBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPWBtn setTitleColor:[UIColor colorWithRed:0.01f green:0.45f blue:0.88f alpha:1.00f] forState:UIControlStateNormal];
    [forgetPWBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.bgView addSubview:forgetPWBtn];
}

-(void)keyBoardWillShow:(NSNotification*)notic{

    //获取键盘的frame
    CGRect keyBoardRect = [[notic.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘的动画持续时间
    CGFloat durTime = [[notic.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //开始动画
    //弹出框的y为：当前键盘的高度-弹出框的高度-间隔
    [UIView animateWithDuration:durTime animations:^{
        
        CGRect rect = self.bgView.frame;
        rect.origin.y = keyBoardRect.origin.y - rect.size.height;
        self.bgView.frame = rect;
        
    }];
    
}


-(void)keyBoardWillHidden{
    
    if (_currentType == PasswordAlertViewType_sheet) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
            
        }];
    }
    
}

-(void)cancleBtnClick{
    for (int i = 0; i<6; i++) {
        UIImageView *imgView = [self.inputBgView viewWithTag:100+i];
        imgView.hidden = YES;
    }
    self.inputTextFiled.text = @"";
    self.tipsLalbe.hidden = YES;
    
    if ([self.delegate respondsToSelector:@selector(PasswordAlertViewDidClickCancleButton)]) {
        [self.delegate PasswordAlertViewDidClickCancleButton];
    }
    [self.inputTextFiled resignFirstResponder];
    self.confirmBtn.userInteractionEnabled = NO;
    self.confirmBtn.backgroundColor = [UIColor grayColor];
    [self removeFromSuperview];

}

-(void)cofirmBtnClick{
    if ([self.delegate respondsToSelector:@selector(PasswordAlertViewCompleteInputWith:)]) {
        [self.delegate PasswordAlertViewCompleteInputWith:self.inputTextFiled.text];
    }
    self.confirmBtn.userInteractionEnabled = NO;
    self.confirmBtn.backgroundColor = [UIColor grayColor];
}

-(void)forgetPWBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(PasswordAlertViewDidClickForgetButton)]) {
        [self.delegate PasswordAlertViewDidClickForgetButton];
    }
    for (int i = 0; i<6; i++) {
        UIImageView *imgView = [self.inputBgView viewWithTag:100+i];
        imgView.hidden = YES;
    }
    self.inputTextFiled.text = @"";
    self.tipsLalbe.hidden = YES;
    
    [self.inputTextFiled resignFirstResponder];
    
    [self removeFromSuperview];
}

-(void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self.inputTextFiled becomeFirstResponder];
	
}

//密码文字改变
-(void)inputTextChanged:(UITextField *)textField{
    
    self.tipsLalbe.hidden = YES;
    NSLog(@"%@",textField.text);
    
    //显示
    for (int i = 1; i<=textField.text.length; i++) {
        UIImageView *imgView = [self.inputBgView viewWithTag:99+i];
        imgView.hidden = NO;
    }
    //隐藏
    for (NSInteger i = textField.text.length+1; i<=6; i++) {
        UIImageView *imgView = [self.inputBgView viewWithTag:99+i];
        imgView.hidden = YES;
    }
    
    switch (_currentType) {
        case PasswordAlertViewType_default:
        {
            if (textField.text.length == 6) {
                self.confirmBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:159/255.0 blue:106/255.0 alpha:1];
                self.confirmBtn.userInteractionEnabled = YES;
            }else{
                self.confirmBtn.backgroundColor = [UIColor grayColor];
                self.confirmBtn.userInteractionEnabled = NO;
                
            }
        }
            break;
        case PasswordAlertViewType_sheet:
        {
            if (textField.text.length == 6) {
                
                if ([self.delegate respondsToSelector:@selector(PasswordAlertViewCompleteInputWith:)]) {
                    [self.delegate PasswordAlertViewCompleteInputWith:self.inputTextFiled.text];
                }
                
            }
        }
            break;
        default:
            break;
    }

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"---------->%@",textField.text);
    if (range.location >= 6) {
        return NO;
    }
    return YES;
}


//密码错误后调用这个方法
-(void)passwordError{
    for (int i = 0; i<6; i++) {
        UIImageView *imgView = [self.inputBgView viewWithTag:100+i];
        imgView.hidden = YES;
    }
    self.inputTextFiled.text = @"";
    self.tipsLalbe.hidden = NO;
}
//密码正确后调用这个方法
-(void)passwordCorrect{
    for (int i = 0; i<6; i++) {
        UIImageView *imgView = [self.inputBgView viewWithTag:100+i];
        imgView.hidden = YES;
    }
    self.inputTextFiled.text = @"";
    self.tipsLalbe.hidden = YES;
    [self removeFromSuperview];
    [self.inputTextFiled resignFirstResponder];
}

@end
