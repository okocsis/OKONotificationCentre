//
//  OKONotificationCentre.m
//  CityMapperChallange
//
//  Created by Kocsis Olivér on 2018. 04. 18..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import "OKONotificationCentre.h"
#import "OKOAssociatedWeakMutableArray.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, OKONotificationQueueType) {
    kOKONotificationQueueTypeRunSynchronously = 0,
    kOKONotificationQueueTypeDispatchQueue,
    kOKONotificationQueueTypeOperationQueue,
};

@interface OKOObserverBlockContainer : NSObject
@property (nonatomic, strong) OKOObserverBlock block;
@property (nonatomic) OKONotificationQueueType queueType;
@property (nonatomic, nullable, weak) NSOperationQueue *operationQueue;
@property (nonatomic, nullable, weak) dispatch_queue_t dispatchQueue;
@property (nonatomic, nullable, weak) id onlyTriggerdBy;
@end
@implementation OKOObserverBlockContainer
-(OKOObserverBlock)block {
    if (_block == nil) {
        return ^(id  _Nonnull sender, id  _Nullable userInfo) {};
    }
    return _block;
}
@end

@interface OKOObserverToken : NSObject<NSCopying>
@property (nonatomic, strong) NSNumber *backingNumber;
+ (instancetype)numberWithUnsignedInteger:(NSUInteger)value;
@end
@implementation OKOObserverToken
- (NSUInteger)hash {
    return self.backingNumber.hash;
}
- (BOOL)isEqual:(id)object {
    return [self.backingNumber isEqual:object];
}
- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}
+ (instancetype)numberWithUnsignedInteger:(NSUInteger)value {
    OKOObserverToken *instance = [[self alloc] init];
    instance.backingNumber = @(value);
    return instance;
}
@end

@interface OKONotificationCentre()

@property (nonatomic, strong) NSMutableDictionary<id<NSCopying>, OKOAssociatedWeakMutableArray<OKOObserverBlockContainer *> *> *observerBlockContainersDict;
@property (nonatomic, strong) OKOAssociatedWeakMutableArray<OKOObserverBlockContainer *> *nilKeyedObserverBlockContainers;
@property (nonatomic, strong) NSMutableDictionary<OKOObserverToken *,id <NSObject>> *compatibilityObserverTokenStore;

@end

@implementation OKONotificationCentre

- (instancetype)init {
    self = [super init];
    if (self) {
        self.observerBlockContainersDict = [NSMutableDictionary new];
        self.nilKeyedObserverBlockContainers = [OKOAssociatedWeakMutableArray new];
        self.compatibilityObserverTokenStore = [NSMutableDictionary new];
    }
    return self;
}



- (void)_triggerNofiyBlock:(OKOObserverBlockContainer *)obc
                    sender:(nullable id)sender
                  userInfo:(nullable id)userInfo {
    switch (obc.queueType) {
        case kOKONotificationQueueTypeRunSynchronously: {
            obc.block(sender, userInfo);
            break;
        }
        case kOKONotificationQueueTypeDispatchQueue: {
            if (obc.dispatchQueue == nil) {
                break;
            }
            dispatch_async(obc.dispatchQueue, ^{
                obc.block(sender, userInfo);
            });
            break;
        }
        case kOKONotificationQueueTypeOperationQueue: {
            if (obc.operationQueue == nil) {
                break;
            }
            [obc.operationQueue addOperationWithBlock:^{
                obc.block(sender, userInfo);
            }];
            break;
        }
        default:
            break;
    }
}

- (void)_triggerEachNotifyBlockInArray:(OKOAssociatedWeakMutableArray<OKOObserverBlockContainer *> *)observerBlockContainersOrNil
                                sender:(nullable id)sender
                              userInfo:(nullable id)userInfo {
    for (OKOObserverBlockContainer *obc in observerBlockContainersOrNil) {
        if (obc.onlyTriggerdBy != nil && obc.onlyTriggerdBy != sender) {
            continue;
        }
        [self _triggerNofiyBlock:obc
                          sender:sender
                        userInfo:userInfo];
    }
}

- (void)postNotificationForKey:(id <NSCopying>)aKey
                        sender:(nullable id)sender
                      userInfo:(nullable id)userInfo {
    NSParameterAssert(aKey);

    OKOAssociatedWeakMutableArray<OKOObserverBlockContainer *> *observerBlockContainersOrNil = nil;
    @synchronized(self.observerBlockContainersDict) {
        observerBlockContainersOrNil = self.observerBlockContainersDict[aKey];
    }

    if (observerBlockContainersOrNil != nil) {
        @synchronized(observerBlockContainersOrNil) {
            [self _triggerEachNotifyBlockInArray:observerBlockContainersOrNil
                                          sender:sender
                                        userInfo:userInfo];
        }
    }

    @synchronized(self.nilKeyedObserverBlockContainers) {
        [self _triggerEachNotifyBlockInArray:self.nilKeyedObserverBlockContainers
                                      sender:sender
                                    userInfo:userInfo];
    }
}

- (void)_addObserverWithKey:(nullable id <NSCopying>)aKey
                  container:(OKOObserverBlockContainer *)obc
              observerOwner:(NSObject *)observerOwner {
    if (aKey == nil) {
        @synchronized(self.nilKeyedObserverBlockContainers) {
            [self.nilKeyedObserverBlockContainers addObject:obc
                                            associatedOwner:observerOwner];
        }
        return;
    }

    OKOAssociatedWeakMutableArray<OKOObserverBlockContainer *> *observerBlockContainersOrNil = nil;
    @synchronized(self.observerBlockContainersDict) {
        observerBlockContainersOrNil = self.observerBlockContainersDict[aKey];
        if (observerBlockContainersOrNil == nil) {
            observerBlockContainersOrNil = [OKOAssociatedWeakMutableArray new];
            self.observerBlockContainersDict[aKey] = observerBlockContainersOrNil;
        }
    }

    @synchronized(observerBlockContainersOrNil) {
        [observerBlockContainersOrNil addObject:obc
                                associatedOwner:observerOwner];
    }
}

- (void)addObserverWithKey:(nullable id <NSCopying>)aKey
            onlyTriggerdBy:(nullable NSObject *)onlyTriggerdBy
             observerOwner:(NSObject *)observerOwner
             observerBlock:(OKOObserverBlock)observerBlock {
    NSParameterAssert(observerOwner);
    NSParameterAssert(observerBlock);

    OKOObserverBlockContainer *obc = [OKOObserverBlockContainer new];
    obc.block = observerBlock;
    obc.queueType = kOKONotificationQueueTypeRunSynchronously;
    obc.onlyTriggerdBy = onlyTriggerdBy;

    [self _addObserverWithKey:aKey
                    container:obc
                observerOwner:observerOwner];
}

- (void)addObserverWithKey:(nullable id <NSCopying>)aKey
            onlyTriggerdBy:(nullable NSObject *)onlyTriggerdBy
        runOnDispatchQueue:(nullable dispatch_queue_t)dispatchQueue
             observerOwner:(NSObject *)observerOwner
             observerBlock:(OKOObserverBlock)observerBlock {
    NSParameterAssert(observerOwner);
    NSParameterAssert(observerBlock);
    
    if (dispatchQueue == nil) {
        [self addObserverWithKey:aKey
                  onlyTriggerdBy:onlyTriggerdBy
                   observerOwner:observerOwner
                   observerBlock:observerBlock];
        return;
    }

    OKOObserverBlockContainer *obc = [OKOObserverBlockContainer new];
    obc.block = observerBlock;
    obc.queueType = kOKONotificationQueueTypeDispatchQueue;
    obc.dispatchQueue = dispatchQueue;
    obc.onlyTriggerdBy = onlyTriggerdBy;

    [self _addObserverWithKey:aKey
                    container:obc
                observerOwner:observerOwner];
}

- (void)addObserverWithKey:(nullable id <NSCopying>)aKey
            onlyTriggerdBy:(nullable NSObject *)onlyTriggerdBy
       runOnOperationQueue:(nullable NSOperationQueue *)operationQueue
             observerOwner:(NSObject *)observerOwner
             observerBlock:(OKOObserverBlock)observerBlock {
    NSParameterAssert(observerOwner);
    NSParameterAssert(observerBlock);

    if (operationQueue == nil) {
        [self addObserverWithKey:aKey
                  onlyTriggerdBy:onlyTriggerdBy
                   observerOwner:observerOwner
                   observerBlock:observerBlock];
        return;
    }

    OKOObserverBlockContainer *obc = [OKOObserverBlockContainer new];
    obc.block = observerBlock;
    obc.queueType = kOKONotificationQueueTypeOperationQueue;
    obc.operationQueue = operationQueue;
    obc.onlyTriggerdBy = onlyTriggerdBy;

    [self _addObserverWithKey:aKey
                    container:obc
                observerOwner:observerOwner];
}

- (id <NSObject>)addObserverWithKey:(nullable id <NSCopying>)aKey
                     onlyTriggerdBy:(nullable NSObject *)onlyTriggerdBy
                      observerBlock:(OKOObserverBlock)observerBlock {
    NSParameterAssert(observerBlock);

    NSObject *token = [NSObject new];
    [self addObserverWithKey:aKey
              onlyTriggerdBy:onlyTriggerdBy
               observerOwner:token
               observerBlock:observerBlock];
    return token;
}

- (id <NSObject>)addObserverWithKey:(nullable id <NSCopying>)aKey
                     onlyTriggerdBy:(nullable NSObject *)onlyTriggerdBy
                 runOnDispatchQueue:(nullable dispatch_queue_t)dispatchQueue
                      observerBlock:(OKOObserverBlock)observerBlock {
    NSParameterAssert(observerBlock);

    NSObject *token = [NSObject new];
    [self addObserverWithKey:aKey
              onlyTriggerdBy:onlyTriggerdBy
          runOnDispatchQueue:dispatchQueue
               observerOwner:token
               observerBlock:observerBlock];
    return token;
}

- (id <NSObject>)addObserverWithKey:(nullable id <NSCopying>)aKey
                     onlyTriggerdBy:(nullable NSObject *)onlyTriggerdBy
                runOnOperationQueue:(nullable NSOperationQueue *)operationQueue
                      observerBlock:(OKOObserverBlock)observerBlock {
    NSParameterAssert(observerBlock);

    NSObject *token = [NSObject new];
    [self addObserverWithKey:aKey
              onlyTriggerdBy:onlyTriggerdBy
         runOnOperationQueue:operationQueue
               observerOwner:token
               observerBlock:observerBlock];
    return token;
}

@end

@implementation OKONotificationCentre(Simplified)
- (void)addObserverWithKey:(nullable id <NSCopying>)aKey
             observerOwner:(NSObject *)observerOwner
             observerBlock:(OKOObserverBlock)observerBlock {
    [self addObserverWithKey:aKey
              onlyTriggerdBy:nil
               observerOwner:observerOwner
               observerBlock:observerBlock];
}
@end

@implementation OKONotificationCentre(ManualRemoval)

+ (void)_removeAllOccurencesOfBlock:(OKOObserverBlock)observerBlock
                         inOBCArray:(OKOAssociatedWeakMutableArray<OKOObserverBlockContainer *> *)assocArray {
    NSIndexSet *indexes =
        [assocArray indexesOfObjectsPassingTest:^BOOL(OKOObserverBlockContainer * _Nonnull obc,
                                                      NSUInteger idx,
                                                      BOOL * _Nonnull stop) {
            return obc.block == observerBlock;
        }];
    [assocArray removeObjectsAtIndexes:indexes];
}

- (void)removeObserverBlockForKey:(nullable id <NSCopying>)aKey
                    observerBlock:(OKOObserverBlock)observerBlock {
    if (observerBlock == nil) {
        return;
    }
    
    if (aKey == nil) {
        @synchronized(self.nilKeyedObserverBlockContainers) {
            [[self class] _removeAllOccurencesOfBlock:observerBlock
                                           inOBCArray:self.nilKeyedObserverBlockContainers];
        }
    } else {
        OKOAssociatedWeakMutableArray<OKOObserverBlockContainer *> *observerBlockContainersOrNil = nil;
        @synchronized(self.observerBlockContainersDict) {
            observerBlockContainersOrNil = self.observerBlockContainersDict[aKey];
        }
        if (observerBlockContainersOrNil != nil) {
            @synchronized(observerBlockContainersOrNil) {
                [[self class] _removeAllOccurencesOfBlock:observerBlock
                                               inOBCArray:observerBlockContainersOrNil];
            }
        }
    }

}

@end

NSString *const kOKONotificationUserInfoInnerNSNotificationObjectKey = @"kOKONotificationUserInfoInnerNSNotificationObjectKey";

@implementation OKONotificationCentre(NSNotificationCenterDropInReplacment)

+ (OKONotificationCentre *)defaultCenter {
    static dispatch_once_t token;
    static OKONotificationCentre *defaultCenter;

    dispatch_once(&token, ^{
        defaultCenter = [self new];
    });

    return defaultCenter;
}

- (void)addObserver:(id)observer
           selector:(SEL)selector
               name:(nullable NSNotificationName)name
             object:(nullable id)obj {
    NSParameterAssert(observer);
    NSParameterAssert(selector);
    NSAssert([observer respondsToSelector:@selector(hash)], @"observer should respond to hash");

    id <NSObject> owner = [self addObserverWithKey:name
                                    onlyTriggerdBy:obj
                                     observerBlock:^(id  _Nullable sender, id  _Nullable userInfo) {
                                         NSNotification *notif = userInfo[kOKONotificationUserInfoInnerNSNotificationObjectKey];
                                         if (notif == nil) {
                                             notif = [NSNotification notificationWithName:name
                                                                                   object:obj
                                                                                 userInfo:userInfo];
                                         }
                                         id stronglyHeldObserver = observer;
                                         if ([stronglyHeldObserver respondsToSelector:selector]) {
                                             void (*funcToCallSelector)(id, SEL, NSNotification *) =
                                             (void (*)(id, SEL, NSNotification *))[stronglyHeldObserver methodForSelector:selector];
                                             funcToCallSelector(stronglyHeldObserver, selector, notif);
                                         }
                                    }];

    OKOObserverToken *token = [OKOObserverToken numberWithUnsignedInteger:[observer hash]];
    self.compatibilityObserverTokenStore[token] = owner;
}

- (void)postNotification:(NSNotification *)notification {
    NSParameterAssert(notification);
    NSDictionary *userInfo = @{ kOKONotificationUserInfoInnerNSNotificationObjectKey : notification };
    [self postNotificationForKey:notification.name
                          sender:notification.object
                        userInfo:userInfo];
}

- (void)postNotificationName:(NSNotificationName)aName
                      object:(nullable id)anObject {
    [self postNotification:[NSNotification notificationWithName:aName
                                                         object:anObject]];
}

- (void)postNotificationName:(NSNotificationName)aName
                      object:(nullable id)anObject
                    userInfo:(nullable NSDictionary *)aUserInfo {
    [self postNotification:[NSNotification notificationWithName:aName
                                                         object:anObject
                                                       userInfo:aUserInfo]];
}

- (void)removeObserver:(id)observer {
    [self removeObserver:observer
                    name:nil
                  object:nil];
}

- (void)removeObserver:(id)observer
                  name:(nullable NSNotificationName)aName
                object:(nullable id)anObject {
    NSParameterAssert(observer);

    if ([observer isKindOfClass:[OKOObserverToken class]]) {
        OKOObserverToken *token = observer;
        self.compatibilityObserverTokenStore[token] = nil;
        return;
    }

    if ([observer respondsToSelector:@selector(hash)]) {
        OKOObserverToken *token = [OKOObserverToken numberWithUnsignedInteger:[observer hash]];
        self.compatibilityObserverTokenStore[token] = nil;
        return;
    }

}

- (OKOObserverToken *)_addObserverForName:(nullable NSNotificationName)name
                                   object:(nullable id)obj
                                    queue:(nullable NSOperationQueue *)queue
                               usingBlock:(void (^)(NSNotification *note))block {
    id <NSObject> owner = [self addObserverWithKey:name
                                    onlyTriggerdBy:obj
                               runOnOperationQueue:queue
                                     observerBlock:^(id  _Nonnull sender, id  _Nullable userInfo) {
                                         NSNotification *notif = userInfo[kOKONotificationUserInfoInnerNSNotificationObjectKey];
                                         if (notif == nil) {
                                             notif = [NSNotification notificationWithName:name
                                                                                   object:obj
                                                                                 userInfo:userInfo];
                                         }
                                         block(notif);
                                     }];
    OKOObserverToken *token = [OKOObserverToken numberWithUnsignedInteger:owner.hash];
    self.compatibilityObserverTokenStore[token] = owner;

    return token;
}

- (id <NSObject>)addObserverForName:(nullable NSNotificationName)name
                             object:(nullable id)obj
                              queue:(nullable NSOperationQueue *)queue
                         usingBlock:(void (^)(NSNotification *note))block {
    return [self _addObserverForName:name object:obj queue:queue usingBlock:block];
}

@end
NS_ASSUME_NONNULL_END
