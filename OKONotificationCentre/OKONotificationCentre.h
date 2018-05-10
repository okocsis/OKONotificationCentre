//
//  OKONotificationCentre.h
//  OKONotificationCentre
//
//  Created by Kocsis Olivér on 2018. 04. 30..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import <Foundation/Foundation.h>

////! Project version number for OKONotificationCentre.
//FOUNDATION_EXPORT double OKONotificationCentreVersionNumber;
//
////! Project version string for OKONotificationCentre.
//FOUNDATION_EXPORT const unsigned char OKONotificationCentreVersionString[];
//
//// In this header, you should import all the public headers of your framework using statements like #import <OKONotificationCentre/PublicHeader.h>

//#import "OKOAssociatedWeakMutableArray.h"


NS_ASSUME_NONNULL_BEGIN
typedef void (^OKOObserverBlock)(_Nullable id sender, _Nullable id userInfo);

@interface OKONotificationCentre<KeyType> : NSObject

- (void)postNotificationForKey:(id <NSCopying>)aKey
                        sender:(nullable id)sender
                      userInfo:(nullable id)userInfo;

- (void)addObserverWithKey:(nullable id <NSCopying>)aKey
            onlyTriggerdBy:(nullable NSObject *)onlyTriggerdBy
             observerOwner:(NSObject *)observerOwner
             observerBlock:(OKOObserverBlock)observerBlock;

- (void)addObserverWithKey:(nullable id <NSCopying>)aKey
            onlyTriggerdBy:(nullable NSObject *)onlyTriggerdBy
        runOnDispatchQueue:(nullable dispatch_queue_t)dispatchQueue
             observerOwner:(NSObject *)observerOwner
             observerBlock:(OKOObserverBlock)observerBlock;

- (void)addObserverWithKey:(nullable id <NSCopying>)aKey
            onlyTriggerdBy:(nullable NSObject *)onlyTriggerdBy
       runOnOperationQueue:(nullable NSOperationQueue *)operationQueue
             observerOwner:(NSObject *)observerOwner
             observerBlock:(OKOObserverBlock)observerBlock;

- (id <NSObject>)addObserverWithKey:(nullable id <NSCopying>)aKey
                     onlyTriggerdBy:(nullable NSObject *)onlyTriggerdBy
                      observerBlock:(OKOObserverBlock)observerBlock;

- (id <NSObject>)addObserverWithKey:(nullable id <NSCopying>)aKey
                     onlyTriggerdBy:(nullable NSObject *)onlyTriggerdBy
                 runOnDispatchQueue:(nullable dispatch_queue_t)dispatchQueue
                      observerBlock:(OKOObserverBlock)observerBlock;

- (id <NSObject>)addObserverWithKey:(nullable id <NSCopying>)aKey
                     onlyTriggerdBy:(nullable NSObject *)onlyTriggerdBy
                runOnOperationQueue:(nullable NSOperationQueue *)operationQueue
                      observerBlock:(OKOObserverBlock)observerBlock;
@end

@interface OKONotificationCentre(ManualRemoval)

- (void) removeObserverBlockForKey:(nullable id <NSCopying>)aKey
                     observerBlock:(OKOObserverBlock)observerBlock;

@end

@interface OKONotificationCentre(Simplified)

- (void)addObserverWithKey:(nullable id <NSCopying>)aKey
             observerOwner:(NSObject *)observerOwner
             observerBlock:(OKOObserverBlock)observerBlock;

@end

@interface OKONotificationCentre(NSNotificationCenterDropInReplacment)

@property (class, readonly, strong) OKONotificationCentre *defaultCenter;

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(nullable id)anObject;

- (void)postNotification:(NSNotification *)notification;
- (void)postNotificationName:(NSNotificationName)aName object:(nullable id)anObject;
- (void)postNotificationName:(NSNotificationName)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;

- (void)removeObserver:(id)observer;
- (void)removeObserver:(id)observer name:(nullable NSNotificationName)aName object:(nullable id)anObject;

- (id <NSObject>)addObserverForName:(nullable NSNotificationName)name object:(nullable id)obj queue:(nullable NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;

@end
NS_ASSUME_NONNULL_END
