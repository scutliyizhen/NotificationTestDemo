//
//  TestObject_2.m
//  ArchitectureProject
//
//  Created by 李义真 on 2016/11/18.
//  Copyright © 2016年 李义真. All rights reserved.
//

#import "TestObject_2.h"

@implementation TestObject_2
- (instancetype)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lyz_notificationResponse:) name:@"lyznotification" object:nil];
    }
    return self;
}

- (void)test2
{
    NSLog(@"TestObject_2 test2:%@",self);
}

- (void)lyz_notificationResponse:(NSNotification*)notification
{
    NSLog(@"TestObject_2  lyz_notificationResponse self:%@ \n class:%@ \n  Time:%f \n isMainThread:%d \n",self,[self class],[[NSDate date] timeIntervalSince1970],[NSThread isMainThread]);
    [self test2];
}
@end
