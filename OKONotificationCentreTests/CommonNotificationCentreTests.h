//
//  OKONotificationCentreTests.m
//  OKONotificationCentreTests
//
//  Created by Oliver Kocsis on 2018. 04. 30..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CommonTestCase.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CommonNotificationCenter
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(nullable id)anObject;

- (void)postNotification:(NSNotification *)notification;
- (void)postNotificationName:(NSNotificationName)aName object:(nullable id)anObject;
- (void)postNotificationName:(NSNotificationName)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;

- (void)removeObserver:(id)observer;
- (void)removeObserver:(id)observer name:(nullable NSNotificationName)aName object:(nullable id)anObject;

- (id <NSObject>)addObserverForName:(nullable NSNotificationName)name object:(nullable id)obj queue:(nullable NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;
@end

@interface CommonNotificationCentreTests : XCTestCase

- (id<CommonNotificationCenter>)defaultCenter; //abstract

- (NSString *)uniqueTestNameForName:(NSString *)name;
- (NSArray<CommonTestCase *> *)testCases;

- (void)_testAddObserver;
- (void)_testRemoveObserver;
- (void)_testRemoveObserverNameObject;
- (void)_testAddObserverObjectQueueUsingBlock;

@end
NS_ASSUME_NONNULL_END
