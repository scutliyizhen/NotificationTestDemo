//
//  ViewController.m
//  NotificationTestDemo
//
//  Created by 李义真 on 2016/11/22.
//  Copyright © 2016年 李义真. All rights reserved.
//

#import "ViewController.h"
#import "TestObject.h"
#import "TestObject_1.h"
#import "TestObject_2.h"
#import "TestObject_3.h"
#import "TestObject_4.h"
#import "TestObject_5.h"

@interface ViewController ()
@property(nonatomic,strong)UIButton* postNotificationBtn;
@property(nonatomic,strong)UIButton* testButton;
@property(nonatomic,strong)TestObject* testObjc;
@property(nonatomic,strong)TestObjectBase* testBase;
@property(nonatomic,strong)TestObject_1* testObjc1;
@property(nonatomic,strong)TestObject_2* testObjc2;
@property(nonatomic,strong)TestObject_3* testObjc3;
@property(nonatomic,strong)TestObject_4* testObjc4;
@property(nonatomic,strong)TestObject_5* testObjc5;
@end

@implementation ViewController
- (void)loadView
{
    [super loadView];
    
   
    
    self.postNotificationBtn.frame = CGRectMake(100, 100, 100, 100);
    self.testButton.frame = CGRectMake(100, 300, 100, 100);
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.testBase = [TestObjectBase new];
//    self.testObjc = [TestObject new];
        self.testObjc1 = [TestObject_1 new];
//        self.testObjc2 = [TestObject_2 new];
//        self.testObjc3 = [TestObject_3 new];
//        self.testObjc4 = [TestObject_4 new];
    //    self.testObjc5 = [TestObject_5 new];
}

- (void)postButtonClick:(UIButton*)btn
{
    NSLog(@"postButtonClick lyznotification before  Time:%f",[[NSDate date] timeIntervalSince1970]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"lyznotification" object:nil];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"lyznotification" object:self];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"lyznotification" object:self userInfo:@{@"key":@"liyizhen"}];
    //    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification new]];
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //      [[NSNotificationCenter defaultCenter] postNotificationName:@"xyznotification" object:nil];
    //    });
    NSLog(@"postButtonClick lyznotification After Time:%f",[[NSDate date] timeIntervalSince1970]);
}

- (void)testButtonClick:(UIButton*)btn
{
    self.testObjc1= nil;
}

- (UIButton*)postNotificationBtn
{
    if(_postNotificationBtn == nil)
    {
        _postNotificationBtn = [UIButton new];
        _postNotificationBtn.backgroundColor = [UIColor blueColor];
        _postNotificationBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_postNotificationBtn setTitle:@"发送通知" forState:UIControlStateNormal];
        [_postNotificationBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [self.view addSubview:_postNotificationBtn];
        
        [_postNotificationBtn addTarget:self action:@selector(postButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _postNotificationBtn;
}

- (UIButton*)testButton
{
    if(_testButton == nil)
    {
        _testButton = [UIButton new];
        _testButton.backgroundColor = [UIColor greenColor];
        _testButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_testButton setTitle:@"测试" forState:UIControlStateNormal];
        [_testButton setTintColor:[UIColor redColor]];
        [_testButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [self.view addSubview:_testButton];
        
        [_testButton addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testButton;
}
@end
