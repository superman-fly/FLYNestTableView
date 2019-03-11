//
//  GlobalConstDefine.h
//  FLYNestTableView
//
//  Created by Fly on 2019/3/11.
//  Copyright © 2019 Fly. All rights reserved.
//

#ifndef GlobalConstDefine_h
#define GlobalConstDefine_h

//状态栏高度
#define SCREEN_STATUS_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)
//tabbar高度
#define SCREEN_TABBAR_HEIGHT ([[UITabBarController alloc] init].tabBar.frame.size.height)
//屏幕宽度
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
//屏幕高度
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
//view高度
#define SCREEN_VIEW_HEIGHT (SCREEN_HEIGHT-SCREEN_STATUS_HEIGHT-44)

#endif /* GlobalConstDefine_h */
