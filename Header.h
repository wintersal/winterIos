//
//  Header.h
//  PandaLifeBusiness
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 jikang. All rights reserved.
//

#ifndef Header_h
#define Header_h


#endif /* Header_h */
#define WDW [UIScreen mainScreen].bounds.size.width
#define WDH [UIScreen mainScreen].bounds.size.height
#define colorWithRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define WDScale WDW/320
#define PropertyStrong         @property(nonatomic,strong)
#define PropertyWeak           @property(nonatomic,weak)
#define PropertyAssign         @property(nonatomic,assign)
#define PropertyCopy           @property(nonatomic,copy)

#define PropertyReadOnlyStrong         @property(nonatomic,readonly,strong)
#define PropertyReadOnlyWeak           @property(nonatomic,readonly,weak)
#define PropertyReadOnlyAssign         @property(nonatomic,readonly,assign)
#define PropertyReadOnlyCopy           @property(nonatomic,readonly,copy)


#define usr [NSUserDefaults standardUserDefaults]
#define WDrandomColor [UIColor colorWithRed:(arc4random()%256)/255.0 green:(arc4random()%256)/255.0 blue:(arc4random()%256)/255.0 alpha:1]

#define IS_3_5_Inch (( [[UIScreen mainScreen] bounds].size.height - 480 == 0) ? YES : NO )
#define IS_4_0_Inch (( [[UIScreen mainScreen] bounds].size.height - 568 == 0) ? YES : NO )
#define IS_4_7_Inch (( [[UIScreen mainScreen] bounds].size.height - 667 == 0) ? YES : NO )
#define IS_5_5_Inch (( [[UIScreen mainScreen] bounds].size.height - 736 == 0) ? YES : NO )

static NSString *WeiXin_AppId = @"wx2e8fc9a51b707d7a";
//static NSString *WeiXin_AppSecreat = @"64ba7a1b06cfb2aa27021312839f7626";

//static NSString *Sina_RedirectURL = @"http://sns.whalecloud.com/sina2/callback";
//
//static NSString *QQ_AppId = @"1105123180";
//static NSString *QQ_AppSecreat = @"r1phaKCda43fibgI";

//屏幕的物理宽度
#define     kScreenWidth            [UIScreen mainScreen].bounds.size.width
//屏幕的物理高度
#define     kScreenHeight           [UIScreen mainScreen].bounds.size.height
//当前设备的版本
#define     kCurrentFloatDevice     [[[UIDevice currentDevice]systemVersion]floatValue]



#define     kCOLOR(a)               [UIColor colorWithRed:a/255.0f green:a/255.0f blue:a/255.0f alpha:1.0f]

#define     kCustomColor(a,b,c)     [UIColor colorWithRed:a/255.0f green:b/255.0f blue:c/255.0f alpha:1.0f]

#define     kRandomColor            [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0]



#define kColorRGBA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:a]
#define kColorRGB(c)    [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:1.0]
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define IWAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]



#define timeOut 10
#define WDScale WDW/320
#define isNewApi [[usr objectForKey:@"isnew"] intValue]
//#define WHostNew @"http://114.55.113.160:9089/bmx_csp_openapi/actionDispatcher.do?"
#define WHostNew @"http://api.84185858.com/index.php?bmxVersion=4.2&bmxSource=ios&buildVersion=30"
//#define WHostNew @"http://api4.84185858.com/index.php?"
#define changeUrl @"http://api.84185858.com/newapp.php"
#define WDCoding @"WRHERBSDH3YQGWG123TB1"
//#import "UIView+WDViewExtend.h"
#import "UIView+Extension.h"
