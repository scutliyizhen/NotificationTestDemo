//
//  TestObjectBase.m
//  ArchitectureProject
//
//  Created by 李义真 on 2016/11/21.
//  Copyright © 2016年 李义真. All rights reserved.
//

#import "TestObjectBase.h"

@implementation TestObjectBase
- (instancetype)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lyz_notificationResponse:) name:@"lyznotification" object:nil];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xyz_notificationResponse) name:@"xyznotification" object:nil];
    }
    return self;
}

- (void)test
{
    NSLog(@"TestObjectBase test:%@",self);
}

- (void)lyz_notificationResponse:(NSNotification*)notification

{
    NSLog(@"TestObjectBase  lyz_notificationResponse self:%@ \n class:%@ \n  Time:%f \n isMainThread:%d \n",self,[self class],[[NSDate date] timeIntervalSince1970],[NSThread isMainThread]);
    [self test];
}

- (void)xyz_notificationResponse
{
    NSLog(@"TestObjectBase  xyz_notificationResponse Time:%f isMainThread:%d \n",[[NSDate date] timeIntervalSince1970],[NSThread isMainThread]);
}

- (void)dealloc
{
    NSLog(@"TestObjectBase  deallocTime:%f",[[NSDate date] timeIntervalSince1970]);
}
@end
