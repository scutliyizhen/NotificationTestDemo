//
//  TestObject_5.m
//  ArchitectureProject
//
//  Created by 李义真 on 2016/11/18.
//  Copyright © 2016年 李义真. All rights reserved.
//

#import "TestObject_5.h"

@implementation TestObject_5
- (instancetype)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lyz_notificationResponse:) name:@"lyznotification" object:nil];
    }
    return self;
}

- (void)test5
{
    NSLog(@"TestObject_5 test5:%@",self);
}

- (void)lyz_notificationResponse:(NSNotification*)notification
{
    NSLog(@"TestObject_5  lyz_notificationResponse self:%@ \n class:%@ \n  Time:%f \n isMainThread:%d \n",self,[self class],[[NSDate date] timeIntervalSince1970],[NSThread isMainThread]);
    [self test5];
}
@end
