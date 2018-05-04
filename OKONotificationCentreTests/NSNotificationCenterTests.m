//
//  NSNotificationCenterTests.m
//  OKONotificationCentreTests
//
//  Created by Kocsis Olivér on 2018. 05. 03..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import "CommonNotificationCentreTests.h"
@interface NSNotificationCenter(dummy)<CommonNotificationCenter>
@end

@interface NSNotificationCenterTests : CommonNotificationCentreTests

@end

@implementation NSNotificationCenterTests

- (id<CommonNotificationCenter>)defaultCenter {
    return NSNotificationCenter.defaultCenter;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testAddObserver {
    [super testAddObserver];
}
- (void)testPostNotification {
    [super testPostNotification];
}
- (void)testPostNotificationNameObject {
    [super testPostNotificationNameObject];
}
- (void)testPostNotificationNameObjectUserInfo {
    [super testPostNotificationNameObjectUserInfo];
}
- (void)testRemoveObserver {
    [super testRemoveObserver];
}
- (void)testRemoveObserverNameObject {
    [super testRemoveObserverNameObject];
}
- (void)testAddObserverObjectQueueUsingBlock {
    [super testAddObserverObjectQueueUsingBlock];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
