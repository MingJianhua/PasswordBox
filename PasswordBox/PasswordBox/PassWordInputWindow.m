//
//  PassWordInputWindow.m
//  PassWordProtectDemo
//
//  Created by Jack on 15-1-22.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "PassWordInputWindow.h"
#import "CommonDef.h"
@implementation PassWordInputWindow

{
    UITextField *_textField;
    int _nInputCount;
    int _nNumber[6];

}

+(PassWordInputWindow *)sharedInstance
{
    static id sharedInstance =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        
    });
    return sharedInstance;
    
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _nInputCount = 0;
    [self refreshPasswordStatus];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xF7F7F7);
        
        int nPannding = 50;
        int nHead = 64;
        int nGridWidth = (_MainScreen_Width - nPannding*2) / 6;
        
        //************
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(nPannding, 64 + 20, _MainScreen_Width - nPannding*2, 20)];
        label.text = @"请输入密码";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];

        //************
        for (int i = 0; i < 6; i++) {
            UITextField *textField= [[UITextField alloc]init];
            textField.frame = CGRectMake(i*nGridWidth + nPannding + 5, 64 + nPannding + 5, nGridWidth - 10, nGridWidth - 10);
            textField.borderStyle = UITextBorderStyleNone;
            textField.tag = 100+i;
            textField.backgroundColor = [UIColor whiteColor];
            textField.font = [UIFont fontWithName:@"Arial" size:(float)nGridWidth/1.8];
            textField.textAlignment = NSTextAlignmentCenter;
            textField.layer.cornerRadius = (nGridWidth - 10)/2.0;
            textField.layer.masksToBounds = YES;
            [self addSubview:textField];
        }
        
        //************
        int nVPannding = 100;
        int nHPannding = 30;
        int nSpace = 20;
        int nButtonGridWidth = (_MainScreen_Width - nHPannding*2) / 3;
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 3; j++) {
                UIButton *btnNumber = [UIButton buttonWithType:UIButtonTypeSystem];
                //UIButton *btnNumber = [[UIButton alloc]init];
                btnNumber.frame = CGRectMake(j*nButtonGridWidth + nHPannding + nSpace/2, i * nButtonGridWidth + 64 + nVPannding + nSpace/2, nButtonGridWidth - nSpace, nButtonGridWidth - nSpace);
                btnNumber.layer.cornerRadius = (nButtonGridWidth - nSpace)/2.0;
                btnNumber.layer.masksToBounds = YES;
                [btnNumber setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btnNumber.backgroundColor = UIColorFromRGB(0xEEEEEE);
                btnNumber.titleLabel.font    = [UIFont systemFontOfSize: (float)nGridWidth/1.8];
                [btnNumber addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                btnNumber.tag = 1000 + i * 3 + j + 1;
                NSString * sValue = [NSString stringWithFormat:@"%d",i * 3 + j + 1];
                [btnNumber setTitle:sValue forState:UIControlStateNormal];
                
                if (i == 3 ) {//btn 0;
                    if (j == 0) {
                        [btnNumber setTitle:@"清空" forState:UIControlStateNormal];
                    }
                    if (j == 1) {
                        btnNumber.tag = 1000;
                        sValue = [NSString stringWithFormat:@"%d",0];
                        [btnNumber setTitle:sValue forState:UIControlStateNormal];
                    }
                    if (j == 2) {
                        [btnNumber setTitle:@"删除" forState:UIControlStateNormal];
                    }
                }
                
                
                //btnNumber.font = [UIFont fontWithName:@"Arial" size:(float)nGridWidth/1.8];
                //btnNumber.textAlignment = NSTextAlignmentCenter;
                
                [self addSubview:btnNumber];
            }
        }
        /*
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 80, 200, 30)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.borderStyle =UITextBorderStyleBezel;
        textField.secureTextEntry = YES;
        [self addSubview:textField];
        
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(10, 130, 60, 30);
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(completeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        //self.backgroundColor = [UIColor grayColor];
        
        _textField = textField;
         */
        
    }
    return self;
}

-(void)show
{
    self.windowLevel = UIWindowLevelAlert;
    [self makeKeyWindow];
    self.hidden =NO;
}
-(void)buttonPressed:(id)sender
{
    UIButton *btnNumber = sender;
    if ( btnNumber.tag - 1000 == 10 )
    {
        _nInputCount = 0;
    }
    else if(btnNumber.tag - 1000 == 12 ) {
        _nInputCount--;
    }
    else
    {
        int number = btnNumber.tag - 1000;
        _nNumber[_nInputCount] = number;
        _nInputCount++;
    }

    [self refreshPasswordStatus];
    if (_nInputCount == 6) {
        [self checkPassword];
    }
    
}


-(void)showErrorAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码错误，正确密码是123456" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)refreshPasswordStatus
{
    for (int i = 0; i < 6; i++) {
        if (i<_nInputCount) {
            UITextField *textFiled = (UITextField *)[self viewWithTag:(100+i)];
            textFiled.backgroundColor = UIColorFromRGB(0xEEEEEE);
        }
        else
        {
            UITextField *textFiled = (UITextField *)[self viewWithTag:(100+i)];
            textFiled.backgroundColor = [UIColor whiteColor];
        }
    }
}
- (void)checkPassword
{
    boolean_t bPasswordRight = true;
    int nPassword[6] = {1,2,3,4,5,6};
    for (int i = 0; i < 6; i++) {
        if (_nNumber[i]!=nPassword[i]) {
            bPasswordRight = false;
            [self showErrorAlertView];
            _nInputCount = 0;
            [self refreshPasswordStatus];
            break;
        }
    }
    if (bPasswordRight) {
        [_textField resignFirstResponder];
        [self resignKeyWindow];
        self.hidden =YES;
    }
    
}
@end
