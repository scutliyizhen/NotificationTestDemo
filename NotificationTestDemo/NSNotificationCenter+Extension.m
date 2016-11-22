//
//  NSNoficationCenter+Extension.m
//  ArchitectureProject
//
//  Created by 李义真 on 2016/11/10.
//  Copyright © 2016年 李义真. All rights reserved.
//

#import <objc/runtime.h>
#import "NSNotificationCenter+Extension.h"
#import "TestObject_1.h"
#import "TestObject.h"
#import "TestObject_2.h"
#import "TestObject_3.h"
#import "TestObject_4.h"
#import "TestObjectBase.h"

//注入对象
@interface GBLInjectObject:NSObject
@property(nonatomic,assign)BOOL flag;
@property(nonatomic,weak)id referenceObj;//外部使用weak属性，防止外部使用者使用已经释放的对象；内部使用__unsafe__unretain
@end

@interface GBLInjectObject()
@property(nonatomic,unsafe_unretained)id _inner_referenceObj;
@end

@implementation GBLInjectObject
- (void)setReferenceObj:(id)referenceObj
{
    _referenceObj = referenceObj;
    self._inner_referenceObj = referenceObj;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self._inner_referenceObj = nil;
}
@end

//基类对象扩展
@interface NSObject(Inject)
@property(nonatomic,strong)GBLInjectObject* injectObj;
@end

static const void* INJECT_OBJECT_KEY = "__inject__object__key__";

@implementation NSObject(Inject)
- (void)setInjectObj:(GBLInjectObject *)injectObj
{
    injectObj.referenceObj = self;
    objc_setAssociatedObject(self, INJECT_OBJECT_KEY, injectObj, OBJC_ASSOCIATION_RETAIN);
}

- (GBLInjectObject*)injectObj
{
    return objc_getAssociatedObject(self, INJECT_OBJECT_KEY);
}
@end

//注入对象扩展
@interface GBLInjectObject(Notification)

static void addObservierToNotificationCenter(id observer,NSString* aName,SEL aSeletor);

static NSString*  injectObjectPrefixString();

static NSString*  injectObjectClass(NSString* prefixString,NSString* observerClassName);

static SEL  injectObjectAddObserverSEL(NSString* prefixString,id observer,SEL sel);

static int getObserverArgumentsCount(NSObject* obj ,SEL aSelector);

- (void)lyz_inject_responseNotificationNoArg;
- (void)lyz_inject_responseNotification:(NSNotification *)notification;
- (void)lyz_inject_responseNotificationWithObj:(NSNotification *)notification obj:(id)obj;
@end

@implementation GBLInjectObject(Notification)
static void addObservierToNotificationCenter(id observer,NSString* aName,SEL aSeletor)
{
    NSObject* obj = observer;
    
    SEL injectSEL = injectObjectAddObserverSEL(injectObjectPrefixString(), obj, aSeletor);
    
    Method injectMethod = nil;
    
    int argsCount = getObserverArgumentsCount(obj, aSeletor);
    if(argsCount == 2)
    {
        injectMethod = class_getInstanceMethod([obj.injectObj class], @selector(lyz_inject_responseNotificationNoArg));
    }
    
    if(argsCount == 3)
    {
        injectMethod = class_getInstanceMethod([obj.injectObj class], @selector(lyz_inject_responseNotification:));
    }
    
    if(argsCount == 4)
    {
        injectMethod = class_getInstanceMethod([obj.injectObj class], @selector(lyz_inject_responseNotificationWithObj:obj:));
    }
    
    if(injectSEL && injectMethod)
    {
        IMP    injectIMP = method_getImplementation(injectMethod);
        
        BOOL methodIMPFlag = class_respondsToSelector([obj.injectObj class], injectSEL);
        
        class_addMethod([obj.injectObj class], injectSEL, injectIMP, method_getTypeEncoding(injectMethod));
        
        methodIMPFlag = class_respondsToSelector([obj.injectObj class], injectSEL);
        
        NSLog(@"");
    }
    
    NSLog(@" addObservierToNotificationCenter \n observer:%@ \n postName:%@ \n observerSelector:%@ \n inject:%@ \n injectSEL:%@",obj,aName,NSStringFromSelector(aSeletor),obj.injectObj,NSStringFromSelector(injectSEL));
}

static int getObserverArgumentsCount(NSObject* obj ,SEL aSelector)
{
//    NSMutableArray* argList = [NSMutableArray new];
//    // 获取方法的参数类型
//    Method responseMethod = class_getInstanceMethod([obj class], aSelector);
//    unsigned int argumentsCount = method_getNumberOfArguments(responseMethod);
//    for (unsigned int argCounter = 0; argCounter < argumentsCount; ++argCounter)
//    {
//        char* arg =  method_copyArgumentType(responseMethod, argCounter);
//        NSString* argType = [NSString stringWithUTF8String:arg];
//        if(argType)
//        {
//            [argList addObject:argType];
//        }
//    }
    NSString* selString = NSStringFromSelector(aSelector);
    NSRange subRange = NSMakeRange(0, 1);
    int argsCount = 0;
    for(int i = 0 ; i < selString.length; i++)
    {
        subRange.location = i;
        NSString* subString = [selString substringWithRange:subRange];
        if([subString isEqualToString:@":"])
        {
            argsCount ++;
        }
    }
    return argsCount + 1 + 1;
}

static NSString*  injectObjectPrefixString()
{
    return @"GBLInjectObject";
}

static NSString*  injectObjectClass(NSString* prefixString,NSString* observerClassName)
{
    if(prefixString.length == 0 || observerClassName.length == 0) return nil;
    
    return [NSString stringWithFormat:@"%@_%@",prefixString,observerClassName];
}

static SEL  injectObjectAddObserverSEL(NSString* prefixString,id observer,SEL sel)
{
    if(prefixString.length == 0 || observer == nil || sel == nil) return nil;
    
    NSString* observerClassName = NSStringFromClass([observer class]);
    
    NSString* selString = NSStringFromSelector(sel);
    
    NSUInteger argsCount = getObserverArgumentsCount(observer, sel);
    NSString* injectSELString = nil;
    if(argsCount == 4)
    {
        injectSELString = [NSString stringWithFormat:@"%@_%@_%@obj:",prefixString,observerClassName,selString];
    }else if(argsCount == 3)
    {
        injectSELString = [NSString stringWithFormat:@"%@_%@_%@",prefixString,observerClassName,selString];
    }else if (argsCount == 2)
    {
        injectSELString = [NSString stringWithFormat:@"%@_%@_%@",prefixString,observerClassName,selString];
    }
    
    return NSSelectorFromString(injectSELString);
}

static SEL parseObserverSELWithInjectObserverSEL(GBLInjectObject* injectObj, SEL injectSEL)
{
    NSString* injectSELString = NSStringFromSelector(injectSEL);
    NSString* injectString = NSStringFromClass([injectObj class]);
    
    NSRange injectStringRange = NSMakeRange(0, 0);
    injectStringRange = [injectSELString rangeOfString:injectString];
    if(injectStringRange.location != NSNotFound)
    {
        NSRange observerSELRange;
        observerSELRange.location = injectStringRange.length + 1;
        observerSELRange.length = injectSELString.length - injectString.length - 1;
        if(observerSELRange.location > injectSELString.length - 1 || observerSELRange.length > injectSELString.length)
        {
            return nil;
        }else
        {
            NSString* observerSELString = [injectSELString substringWithRange:observerSELRange];
            
            return NSSelectorFromString(observerSELString);
        }
    }else
    {
        return nil;
    }
}

- (void)lyz_inject_responseNotificationNoArg
{
    [self notificationResponse:nil cmd:_cmd observer:self.referenceObj obj:nil];
}

- (void)lyz_inject_responseNotification:(NSNotification *)notification
{
    [self notificationResponse:notification cmd:_cmd observer:self.referenceObj obj:nil];
}

- (void)lyz_inject_responseNotificationWithObj:(NSNotification *)notification obj:(id)obj
{
    [self notificationResponse:notification cmd:_cmd observer:self.referenceObj obj:obj];
}

- (void)notificationResponse:(NSNotification*)notification
                         cmd:(SEL)cmd
                    observer:(id)observer
                         obj:(id)obj
{
    if(cmd == nil || observer == nil) return;
    
    //此时self 指的是GBLInjectObject实例
    NSObject* objObserver = observer;
    SEL observerSEL = parseObserverSELWithInjectObserverSEL(objObserver.injectObj, cmd);
    int argsCount = getObserverArgumentsCount(observer, observerSEL);
 
    Method observerMethod = class_getInstanceMethod([objObserver class], observerSEL);
    IMP observerMethodIMP = method_getImplementation(observerMethod);
    
    NSLog(@"notificationResponse \n observer:%@ \n observerSEL:%@ \n notification:%@ \n inject:%@ \n injectCmd:%@ \n argList.count:%lu",objObserver,NSStringFromSelector(observerSEL),notification,objObserver.injectObj,NSStringFromSelector(cmd),(unsigned long)argsCount);
    
    if(argsCount == 2)
    {
  
//        if([NSStringFromSelector(observerSEL) isEqualToString:@"_willResume"])
//        {
//            void (*func)(id, SEL,NSNotification *) = (void *)observerMethodIMP;
//            func(objObserver,observerSEL,notification);
//        }else
//        {
            void (*func)(id, SEL) = (void *)observerMethodIMP;
            NSLog(@"notificationResponse before");
        if(func != NULL)
        {
        	func(objObserver,observerSEL);
        }
            //        [objObserver performSelector:observerSEL withObject:nil];
            NSLog(@"notificationResponse after");
//        }
        
    }else if(argsCount == 3)
    {
        void (*func)(id, SEL,NSNotification *) = (void *)observerMethodIMP;
        if(func != NULL)
        {
        	 func(objObserver,observerSEL,notification);
        }
    }else if (argsCount == 4)
    {
        void (*func)(id, SEL,NSNotification *,id) = (void *)observerMethodIMP;
		
        if(func != NULL)
        {
        	func(objObserver,observerSEL,notification,obj);
        }
    }
}
@end

//通知扩展
@implementation NSNotificationCenter(Extension)

#ifdef GBL_NOTIFICATIONCENTER_SWITCH
+ (void)load
{
    //交换注册通知方法
    Method orgObserverMethod = class_getInstanceMethod([self class], @selector(addObserver:selector:name:object:));
    Method lyzObserverMethod = class_getInstanceMethod([self class], @selector(lyz_addObserver:selector:name:object:));
    method_exchangeImplementations(orgObserverMethod, lyzObserverMethod);
    
    //交换注册通知方法
    Method orgRemoveMethod1 = class_getInstanceMethod([self class], @selector(removeObserver:));
    Method lyzRemoveMethod1 = class_getInstanceMethod([self class], @selector(lyz_removeObserver:));
    method_exchangeImplementations(orgRemoveMethod1, lyzRemoveMethod1);
    
    Method orgRemoveMethod2 = class_getInstanceMethod([self class], @selector(removeObserver:name:object:));
    Method lyzRemoveMethod2 = class_getInstanceMethod([self class], @selector(lyz_removeObserver:name:object:));
    method_exchangeImplementations(orgRemoveMethod2, lyzRemoveMethod2);
}
#endif

- (void)lyz_removeObserver:(id)observer name:(NSNotificationName)aName object:(id)anObject
{
    NSObject* obj = observer;
    if([obj isKindOfClass:[GBLInjectObject class]])
    {
        [self lyz_removeObserver:obj name:aName object:anObject];
    }else
    {
        if(obj.injectObj)
        {
            [self lyz_removeObserver:obj.injectObj name:aName object:anObject];
        }else
        {
            [self lyz_removeObserver:obj name:aName object:anObject];
        }
    }
}

- (void)lyz_removeObserver:(id)observer
{
    NSObject* obj = observer;
    if([obj isKindOfClass:[GBLInjectObject class]])
    {
        [self lyz_removeObserver:obj];
    }else
    {
        if(obj.injectObj)
        {
            [self lyz_removeObserver:obj.injectObj];
        }else
        {
            [self lyz_removeObserver:obj];
        }
    }
}


- (void)lyz_addObserver:(id)observer
               selector:(SEL)aSelector
                   name:(NSNotificationName)aName
                 object:(id)anObject
{
    if([NSThread isMainThread])
    {
        [self rigisterObserverNotification:observer selector:aSelector name:aName object:anObject];
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self rigisterObserverNotification:observer selector:aSelector name:aName object:anObject];
        });
    }
}

- (void)rigisterObserverNotification:(id)observer
                            selector:(SEL)aSelector
                                name:(NSNotificationName)aName
                              object:(id)anObject
{
    
//    BOOL flag = [observer isKindOfClass:[TestObject class]];
//    BOOL flagBase = [observer isKindOfClass:[TestObjectBase class]];
//    BOOL flag_1 = [observer isKindOfClass:[TestObject_1 class]];
//    BOOL flag_2 = [observer isKindOfClass:[TestObject_2 class]];
//    BOOL flag_3 = [observer isKindOfClass:[TestObject_3 class]];
//    BOOL flag_4 = [observer isKindOfClass:[TestObject_4 class]];
//    if(flag || flag_1 || flag_2 || flag_3 || flag_4 || flagBase)
//    if(![NSStringFromClass([observer class]) isEqualToString:@"UIMotionEvent"])
    if([observer isKindOfClass:[NSObject class]])
    {
        NSObject* obj = observer;
        if(obj.injectObj == nil)//保证仅注入一次内部对象
        {
            NSString* objClassString = NSStringFromClass([obj class]);
            NSString* subClassString = injectObjectClass(injectObjectPrefixString(), objClassString);
            const char *subclassName = subClassString.UTF8String;
            Class subclass = objc_getClass(subclassName);
            if (subclass == nil)
            {
                subclass = objc_allocateClassPair([GBLInjectObject class], subclassName, 0);
                objc_registerClassPair(subclass);
            }
            obj.injectObj = [subclass new];
        }
        
        addObservierToNotificationCenter(observer, aName, aSelector);
        
        SEL injectSEL = injectObjectAddObserverSEL(injectObjectPrefixString(), observer, aSelector);
        NSLog(@"lyz_addObserver observer:%@ \n postName:%@ \n selector:%@ \n obj.injectObj=%@ \n injectSEL:%@",obj,aName,NSStringFromSelector(aSelector),obj.injectObj,NSStringFromSelector(injectSEL));
        [self lyz_addObserver:obj.injectObj selector:injectSEL name:aName object:anObject];
        
         //NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    }else
    {
         [self lyz_addObserver:observer selector:aSelector name:aName object:anObject];
    }
}
@end














