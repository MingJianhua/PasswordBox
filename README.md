用UIWindow开发漂亮的锁屏密码保护功能

本文介绍一个类似于支付宝或网银等APP返回Home重新打开后手势或密码解锁功能的实现方式

先上几张demo图片

Simulator Screen Shot 2017年2月21日 下午6.01.12.pngSimulator Screen Shot 2017年2月21日 下午6.01.42.png

涉及到的知识点



UIWindow

AutoLayout

UIButton,UITextField

AppDelegate



开发



基本思路：

1、当刚进入APP时将锁屏界面Show出来，解锁成功后，锁屏界面消失。

2、按下Home按钮时，App进入后台，在进入后台的代码出将锁屏界面Show出来，解锁成功后，锁屏界面消失。这里的锁屏界面我用UIWindow来编写。



编写UIWidow锁屏界面



1.首先新建一个继承UIWindow的类，我在这个项目中取名为PasswordInputWindow。

2.PasswordInputWindow设计成一个单例模型。

.h文件中添加两个方法，单例和show。



#PasswordInputWindow.h

@interface PassWordInputWindow : UIWindow
+(PassWordInputWindow *)sharedInstance;
-(void)show;
@end



初始化代码

#PasswordInputWindow.h

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
                btnNumber.layer.cornerRadius = (nButtonGridWidth - nSpace)/2.0;//Button 画成圆形
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
                [self addSubview:btnNumber];
            }
        }
    }
    return self;
}













3.Show PasswordInputWindow




#PasswordInputWindow.h

-(void)show
{
    self.windowLevel = UIWindowLevelAlert;
    [self makeKeyWindow];
    self.hidden =NO;
}



上面代码中，有一个windowLevel的属性，这个是设置UIWindow所在的层级，系统提供了三种层级，也可以自定义层级，因为改值是一个long类型的

UIKIT_EXTERN const UIWindowLevel UIWindowLevelNormal; ／／最下层

UIKIT_EXTERN const UIWindowLevel UIWindowLevelAlert; ／／最上层

UIKIT_EXTERN const UIWindowLevel UIWindowLevelStatusBar; ／／中间层





如果密码输错，则弹出警告框。




代码中makeKeyWindow是将该UIWindow设置为键盘可响应的状态。



4.在AppDelegate.m中添加代码

#PasswordInputWindow.h

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[LockScreen shareInstance] show];
}


程序进入后台时，将锁屏界面show出来。

在ViewController的ViewDidAppear里，第一次启动时将锁屏界面show出来。

#PasswordInputWindow.h

- (void)viewDidAppear:(BOOL)animated
{
    if (g_bFirst) {
        g_bFirst = false;
        [[PassWordInputWindow sharedInstance] show];
    }
}







后记：

UIWindow是UIView的子类，所以可以使用UIView中的方法，例如：addSubview等。

本文章的源代码在github上，地址：https://github.com/MingJianhua/PasswordBox。
