//
//  OKONotificationCentreTests.m
//  OKONotificationCentreTests
//
//  Created by Kocsis Olivér on 2018. 04. 30..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import <XCTest/XCTest.h>
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

- (void)testAddObserver;
- (void)testPostNotification;
- (void)testPostNotificationNameObject;
- (void)testPostNotificationNameObjectUserInfo;
- (void)testRemoveObserver;
- (void)testRemoveObserverNameObject;
- (void)testAddObserverObjectQueueUsingBlock;

@end
NS_ASSUME_NONNULL_END
