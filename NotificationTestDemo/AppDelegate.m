//
//  AppDelegate.m
//  NotificationTestDemo
//
//  Created by 李义真 on 2016/11/22.
//  Copyright © 2016年 李义真. All rights reserved.
//

#import "AppDelegate.h"
#include <execinfo.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    InstallSignalHandler();//信号量截断
    InstallUncaughtExceptionHandler();//系统异常捕获
    return YES;
}

void SignalExceptionHandler(int signal)
{
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:@"Stack:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    
    NSLog(@"callBack%@",mstr);
}


void InstallSignalHandler(void)
{
    signal(SIGHUP, SignalExceptionHandler);
    signal(SIGINT, SignalExceptionHandler);
    signal(SIGQUIT, SignalExceptionHandler);
    
    signal(SIGTRAP, SignalExceptionHandler);
    signal(SIGABRT, SignalExceptionHandler);
    signal(SIGILL, SignalExceptionHandler);
    signal(SIGSEGV, SignalExceptionHandler);
    signal(SIGFPE, SignalExceptionHandler);
    signal(SIGBUS, SignalExceptionHandler);
    signal(SIGPIPE, SignalExceptionHandler);
    
    signal(SIGKILL, SignalExceptionHandler);
     signal(SIGSEGV, SignalExceptionHandler);
     signal(SIGALRM, SignalExceptionHandler);
     signal(SIGTERM, SignalExceptionHandler);
     signal(SIGCHLD, SignalExceptionHandler);
     signal(SIGCONT, SignalExceptionHandler);
     signal(SIGTSTP, SignalExceptionHandler);
     signal(SIGSTOP, SignalExceptionHandler);
     signal(SIGTTIN, SignalExceptionHandler);
     signal(SIGXCPU, SignalExceptionHandler);
     signal(SIGXFSZ, SignalExceptionHandler);
     signal(SIGVTALRM, SignalExceptionHandler);
     signal(SIGPROF, SignalExceptionHandler);
     signal(SIGWINCH, SignalExceptionHandler);
    signal(SIGIO, SignalExceptionHandler);
    signal(SIGSYS, SignalExceptionHandler);
}

void HandleException(NSException *exception)
{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    NSLog(@"HandleException :%@", exceptionInfo);
 
}

void InstallUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
