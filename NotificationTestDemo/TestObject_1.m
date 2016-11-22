//
//  TestObject_1.m
//  ArchitectureProject
//
//  Created by 李义真 on 2016/11/18.
//  Copyright © 2016年 李义真. All rights reserved.
//

#import "TestObject_1.h"

@implementation TestObject_1
- (instancetype)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lyz_notificationResponse) name:@"lyznotification" object:nil];
    }
    return self;
}

- (void)test1
{
    NSLog(@"TestObject_1 test1:%@",self);
}

- (void)lyz_notificationResponse
{
    NSLog(@"TestObject_1  lyz_notificationResponse self:%@ \n class:%@ \n  Time:%f \n isMainThread:%d \n",self,[self class],[[NSDate date] timeIntervalSince1970],[NSThread isMainThread]);
    [self test1];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
