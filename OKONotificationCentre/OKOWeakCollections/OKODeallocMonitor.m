//
//  OKODeallocMonitorObject.m
//  CityMapperChallange
//
//  Created by Kocsis Olivér on 2018. 04. 20..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import "OKODeallocMonitor.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface OKODeallocSpyingObject : NSObject
@property (nonatomic, weak) id<OKODeallocMonitorObjectDelegate> delegate;
@property (nonatomic) BOOL justBeingResetPrivately;
@end
@implementation OKODeallocSpyingObject
- (void)dealloc {
    if (self.justBeingResetPrivately) {
        return;
    }
    [self.delegate didDeallocMonitoredObject];
}
@end

@interface OKODeallocMonitor()<OKODeallocMonitorObjectDelegate> {
    __weak NSObject *_Nullable _monitoredObject;
}

@property (nonatomic, nullable, weak) OKODeallocSpyingObject *spy;

@end

@implementation OKODeallocMonitor

- (nullable instancetype)init {
    NSAssert(false, @"");
    return nil;
}

- (instancetype)initWithMonitoredObject:(nullable NSObject *)monitoredObject {

    self = [super init];
    if (self) {
        [self registerMonitoredObject:monitoredObject];
    }
    return self;
}

+ (instancetype)monitorWithObject:(nullable NSObject *)monitoredObject {
    return [[self alloc] initWithMonitoredObject:monitoredObject];
}

- (void)registerMonitoredObject:(nullable NSObject *)aMonitoredObject {
    if (_monitoredObject == nil && aMonitoredObject == nil) {

    } else if (_monitoredObject != nil && aMonitoredObject == nil) {

        [self resetMonitoringFor:_monitoredObject];
        _monitoredObject = nil;

    } else if (_monitoredObject == nil && aMonitoredObject != nil) {

        [self startMonitoringFor:aMonitoredObject];
        _monitoredObject = aMonitoredObject;

    } else if (_monitoredObject != nil && aMonitoredObject != nil) {

        [self resetMonitoringFor:_monitoredObject];
        [self startMonitoringFor:aMonitoredObject];
        _monitoredObject = aMonitoredObject;

    }
}

- (void)startMonitoringFor:(NSObject *) aMonitoredObject {
    if (aMonitoredObject == nil) {
        return;
    }
    @autoreleasepool {
        OKODeallocSpyingObject *spy = [OKODeallocSpyingObject new];
        self.spy = spy;
        self.spy.delegate = self;

        NSObject *owner = aMonitoredObject;
        const void *key = (__bridge const void * _Nonnull)(self.spy);
        id value = spy;
        objc_setAssociatedObject(owner, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (void)resetMonitoringFor:(NSObject *) aMonitoredObject {
    if (aMonitoredObject == nil || self.spy == nil) {
        return;
    }
    self.spy.justBeingResetPrivately = YES;
    NSObject *owner = aMonitoredObject;
    const void *key = (__bridge const void * _Nonnull)(self.spy);
    id value = nil;
    objc_setAssociatedObject(owner, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)stopMonitoring {
    [self registerMonitoredObject:nil];
}

- (void)dealloc {
    [self stopMonitoring];
}

#pragma mark - OKODeallocMonitorObjectDelegate
- (void)didDeallocMonitoredObject {
    [self.delegate didDeallocMonitoredObject];
}

@end
NS_ASSUME_NONNULL_END
