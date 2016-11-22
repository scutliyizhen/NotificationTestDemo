//
//  TestObject_3.m
//  ArchitectureProject
//
//  Created by 李义真 on 2016/11/18.
//  Copyright © 2016年 李义真. All rights reserved.
//

#import "TestObject_3.h"

@implementation TestObject_3
- (instancetype)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lyz_notificationResponse:) name:@"lyznotification" object:nil];
    }
    return self;
}

- (void)test3
{
    NSLog(@"TestObject_3 test3:%@",self);
}

- (void)lyz_notificationResponse:(NSNotification*)notification
{
    NSLog(@"TestObject_3  lyz_notificationResponse self:%@ \n class:%@ \n  Time:%f \n isMainThread:%d \n",self,[self class],[[NSDate date] timeIntervalSince1970],[NSThread isMainThread]);
    [self test3];
}
@end
