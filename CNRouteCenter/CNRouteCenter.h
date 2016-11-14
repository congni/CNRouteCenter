//
//  @fileName  CNRouteCenter.h
//  @abstract  跳转路由中间件
//  @author    葱泥 创建于 16/11/11.
//  @revise    葱泥 最后修改于 16/11/11.
//  @version   当前版本号 1.0(16/11/11).
//  Copyright © 2016年 congni. All rights reserved.
//  此源码参考CTMediator源码，把里面的关乎业务逻辑层的东西，剥离出来，给到逻辑层去处理

#import <Foundation/Foundation.h>


/**
 业务逻辑处理
 */
@protocol CNRouteCenterDelegate <NSObject>

/**
 获取target

 @param url 远程url

 @return targetName
 */
- (NSString *)targetName:(NSURL *)url;

/**
 获取action

 @param url 远程url

 @return actionName
 */
- (NSString *)actionName:(NSURL *)url;

/**
 获取参数

 @param url 远程url

 @return NSDictionary
 */
- (NSDictionary *)params:(NSURL *)url;

/**
 无对象的时候跳转对象

 @return targetName
 */
- (NSString *)defaultTargetName;

/**
 无对象的时候跳转对象的方法

 @return actionName
 */
- (NSString *)defaultActionName;

@end


@interface CNRouteCenter : NSObject

/**
 业务逻辑处理对象(此对象必须设置，不可为空)
 */
@property (nonatomic, strong) id<CNRouteCenterDelegate> handleRouteCenter;

/**
 单例

 @return self
 */
+ (instancetype)sharedInstance;

/**
 远程App调用入口

 @param url    url格式地址(这里的具体格式，根据不同业务逻辑来处理，这里会直接交给各项目来处理)
 @param target 处理结果回调

 @return 跳转对象: NO/nil不能跳转，
 */
- (id)performActionWithUrl:(NSURL *)url completionDeleagte:(id)target;

/**
 本地组件调用入口

 @param targetName        对象
 @param actionName        方法
 @param params            参数
 @param shouldCacheTarget 是否缓存

 @return 跳转对象: NO/nil不能跳转
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

/**
 删除对象缓存

 @param targetName 跳转对象名称
 */
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;

@end
