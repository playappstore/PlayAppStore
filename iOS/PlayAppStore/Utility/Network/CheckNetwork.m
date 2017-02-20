//
//  CheckNetwork.m
//  NetWorkDemo
//
//  Created by mino on 11-7-18.
//  Copyright 2011 gdkxjszyxy. All rights reserved.
//

#import "CheckNetwork.h"
#import "Reachability.h"
@implementation CheckNetwork
+(BOOL)isExistenceNetwork
{
	BOOL isExistenceNetwork;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:
			isExistenceNetwork=TRUE;       
            break;
    }
//	if (!isExistenceNetwork) {
//		UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", @"") message:NSLocalizedString(@"网络好像有点问题", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil,nil];
//		[myalert show];
//	}
	return isExistenceNetwork;
}
@end
