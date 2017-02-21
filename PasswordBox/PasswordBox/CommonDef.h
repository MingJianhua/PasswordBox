//
//  CommonDef.h
//  Noise
//
//  Created by MingJianhua on 15/9/30.
//  Copyright © 2015年 MingJianhua. All rights reserved.
//

#ifndef CommonDef_h
#define CommonDef_h
//设备屏幕大小
#define _MainScreenFrame   [[UIScreen mainScreen] bounds]
//设备屏幕宽
#define _MainScreen_Width  _MainScreenFrame.size.width
#define _MainScreen_Height _MainScreenFrame.size.height

#define autoSizeScaleX _MainScreen_Width/320
#define autoSizeScaleY _MainScreenFrame.size.height/568
//设备屏幕高 20,表示状态栏高度.如3.5inch 的高,得到的__MainScreenFrame.size.height是480,而去掉电量那条状态栏,我们真正用到的是460;

// 判断设备版本
/*****************************************************/

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGB_Alpha(rgbValue,talpha) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:talpha]

#endif /* CommonDef_h */
