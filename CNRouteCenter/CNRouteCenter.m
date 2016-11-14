//
//  CNRouteCenter.m
//  CNRouteCenterDemo
//
//  葱泥 创建于 16/11/11.
//  Copyright © 2016年 congni. All rights reserved.
//

#import "CNRouteCenter.h"


@interface CNRouteCenter()

@property (nonatomic, strong) NSMutableDictionary *cachedTargetMulDictionary;

@end


@implementation CNRouteCenter


#pragma mark - public methods
#pragma mark 单例
+ (instancetype)sharedInstance {
    static CNRouteCenter *routeCenter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        routeCenter = [[CNRouteCenter alloc] init];
    });
    
    return routeCenter;
}

#pragma mark 远程App调用入口
- (id)performActionWithUrl:(NSURL *)url completionDeleagte:(id)target {
    NSString *targetName = [self.handleRouteCenter targetName:url];
    NSString *actionName = [self.handleRouteCenter actionName:url];
    NSDictionary *paramsDictionary = [self.handleRouteCenter params:url];
    
    id result = [self performTarget:targetName action:actionName params:paramsDictionary shouldCacheTarget:NO];
    
    return result;
}

#pragma mark 本地接口调取入口
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    NSAssert(self.handleRouteCenter == nil, @"请先设置业务逻辑处理对象！");
    
    id targetObject = self.cachedTargetMulDictionary[targetName];
    
    if (!targetObject) {
        Class targetClass = NSClassFromString(targetName);
        targetObject = [[targetClass alloc] init];
    }
    
    if (!targetObject) {
        Class targetClass = NSClassFromString([self.handleRouteCenter defaultTargetName]);
        targetObject = [[targetClass alloc] init];
    }
    
    SEL action = NSSelectorFromString(actionName);
    
    if ([targetObject respondsToSelector:action]) {
        // 有此方法
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [targetObject performSelector:action withObject:params];
#pragma clang diagnostic pop
    } else {
        // 无此方法
        action = NSSelectorFromString([self.handleRouteCenter defaultActionName]);
        NSAssert(![targetObject respondsToSelector:action], @"默认对象中，没有默认方法啊！请实现");
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [targetObject performSelector:action withObject:params];
#pragma clang diagnostic pop
    }
    
    return nil;
}

#pragma mark 移除对象缓存
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName {
    if ([[self.cachedTargetMulDictionary allKeys] containsObject:targetName]) {
        [self.cachedTargetMulDictionary removeObjectForKey:targetName];
    }
}

#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTargetMulDictionary {
    if (_cachedTargetMulDictionary == nil) {
        _cachedTargetMulDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _cachedTargetMulDictionary;
}

@end
