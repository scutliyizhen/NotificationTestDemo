//
//  TestObject_4.m
//  ArchitectureProject
//
//  Created by 李义真 on 2016/11/18.
//  Copyright © 2016年 李义真. All rights reserved.
//

#import "TestObject_4.h"

@implementation TestObject_4
- (instancetype)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lyz_notificationResponse:) name:@"lyznotification" object:nil];
    }
    return self;
}

- (void)test4
{
    NSLog(@"TestObject_4 test4:%@",self);
}

- (void)lyz_notificationResponse:(NSNotification*)notification
{
    NSLog(@"TestObject_4  lyz_notificationResponse self:%@ \n class:%@ \n  Time:%f \n isMainThread:%d \n",self,[self class],[[NSDate date] timeIntervalSince1970],[NSThread isMainThread]);
     [self test4];
}
@end
