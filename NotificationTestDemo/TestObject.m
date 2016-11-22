//
//  TestObject.m
//  ArchitectureProject
//
//  Created by 李义真 on 2016/11/9.
//  Copyright © 2016年 李义真. All rights reserved.
//

#import <objc/runtime.h>
#import "TestObject.h"

@implementation TestObject
- (void)lyz_notificationResponse:(NSNotification *)notification
{
   
    
    [super lyz_notificationResponse:notification];
    
    
    NSLog(@"TestObject  lyz_notificationResponse self:%@ \n class:%@ \n  Time:%f \n isMainThread:%d \n",self,[self class],[[NSDate date] timeIntervalSince1970],[NSThread isMainThread]);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
