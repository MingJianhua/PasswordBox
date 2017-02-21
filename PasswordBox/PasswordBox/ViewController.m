//
//  ViewController.m
//  PasswordBox
//
//  Created by MingJianhua on 2017/2/21.
//  Copyright © 2017年 MingJianhua. All rights reserved.
//

#import "ViewController.h"
#import "PassWordInputWindow.h"
bool g_bFirst = true;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor redColor];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidAppear:(BOOL)animated
{
    if (g_bFirst) {
        g_bFirst = false;
        [[PassWordInputWindow sharedInstance] show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
