//
//  PASDeviceDefine.h
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/2/27.
//  Copyright © 2017年 Winn. All rights reserved.
//

#ifndef PASDeviceDefine_h
#define PASDeviceDefine_h
#import "UIView+ViewAddtions.h"

#define IOS_2_0 @"2.0"
#define IOS_3_0 @"3.0"
#define IOS_4_0 @"4.0"
#define IOS_5_0 @"5.0"
#define IOS_6_0 @"6.0"
#define IOS_7_0 @"7.0"
#define IOS_8_0 @"8.0"
#define IOS_9_0 @"9.0"
#define IOS_10_0 @"10.0"

#define IOSVersion      [[UIDevice currentDevice].systemVersion floatValue]
#define IOS10_OR_LATER       ( [[[UIDevice currentDevice] systemVersion] compare:IOS_10_0 options:NSNumericSearch] != NSOrderedAscending )
#define IOS9_OR_LATER       ( [[[UIDevice currentDevice] systemVersion] compare:IOS_9_0 options:NSNumericSearch] != NSOrderedAscending )
#define IOS8_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:IOS_8_0 options:NSNumericSearch] != NSOrderedAscending )
#define IOS7_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:IOS_7_0 options:NSNumericSearch] != NSOrderedAscending )
#define IOS6_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:IOS_6_0 options:NSNumericSearch] != NSOrderedAscending )
#define IOS5_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:IOS_5_0 options:NSNumericSearch] != NSOrderedAscending )
#define IOS4_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:IOS_4_0 options:NSNumericSearch] != NSOrderedAscending )
#define IOS3_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:IOS_3_0 options:NSNumericSearch] != NSOrderedAscending )

#define IOS8_EARLIER		( !IOS8_OR_LATER )
#define IOS7_EARLIER		( !IOS7_OR_LATER )
#define IOS6_EARLIER		( !IOS6_OR_LATER )
#define IOS5_EARLIER		( !IOS5_OR_LATER )
#define IOS4_EARLIER		( !IOS4_OR_LATER )

#endif /* PASDeviceDefine_h */
