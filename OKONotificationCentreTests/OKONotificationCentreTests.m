//
//  OKONotificationCentreTests.m
//  OKONotificationCentreTests
//
//  Created by Kocsis Olivér on 2018. 05. 09..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import "CommonNotificationCentreTests.h"
#import "OKONotificationCentre.h"

@interface OKONotificationCentre(dummy)<CommonNotificationCenter>
@end

@interface OKONotificationCentreTests : CommonNotificationCentreTests

@end

@implementation OKONotificationCentreTests

- (id<CommonNotificationCenter>)defaultCenter {
    return OKONotificationCentre.defaultCenter;
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

- (void)testBlockAutoRemovalOnOwnersDeath {
    OKONotificationCentre *center = OKONotificationCentre.defaultCenter;

    __weak NSObject *weakOwner = nil;
    __weak id weakBlock = nil;
    NSString *key = [self uniqueTestNameForName:@"BlockAutoRemovalOnOwnersDeath"];


    @autoreleasepool {
        NSObject *owner = [NSObject new];
        weakOwner = owner;
        id globalblock = ^(id _Nullable sender, id _Nullable userInfo) {};
        weakBlock = globalblock;

        [center addObserverWithKey:key
                     observerOwner:owner
                     observerBlock:globalblock];

        [center postNotificationForKey:key
                                sender:nil
                              userInfo:nil];
    }
    XCTAssertNil(weakOwner);
// the block is still in memory since it was optimised to be a global pointer
    //FIXME
    XCTAssertNotNil(weakBlock);

}

- (void)testBlockAutoRemovalRetainCycle {
    OKONotificationCentre *center = OKONotificationCentre.defaultCenter;

    __weak NSObject *weakOwner = nil;
    __weak id weakBlock = nil;
    NSString *key = [self uniqueTestNameForName:@"BlockAutoRemovalRetainCycle"];

    @autoreleasepool {
        NSObject *owner = [NSObject new];
        weakOwner = owner;
        id mallocBlock = ^(id _Nullable sender, id _Nullable userInfo) {
            NSLog(@"%@",owner); // <------ DO NOT DO THIS
        };
        weakBlock = mallocBlock;

        [center addObserverWithKey:key
                     observerOwner:owner
                     observerBlock:mallocBlock];

        [center postNotificationForKey:key
                                sender:nil
                              userInfo:nil];
    }
    XCTAssertNotNil(weakBlock);
    XCTAssertNotNil(weakOwner);
    [center removeObserverBlockForKey:key
                        observerBlock:weakBlock];
    XCTAssertNil(weakBlock);
    XCTAssertNil(weakOwner);
}

- (void)testBlockAutoRemovalRetainCycleFix {
    OKONotificationCentre *center = OKONotificationCentre.defaultCenter;

    __weak NSObject *weakOwner = nil;
    __weak id weakBlock = nil;
    NSString *key = [self uniqueTestNameForName:@"BlockAutoRemovalRetainCycleFix"];

    @autoreleasepool {
        NSObject *owner = [NSObject new];
        weakOwner = owner;
        id mallocBlock = ^(id _Nullable sender, id _Nullable userInfo) {
            NSLog(@"%@",weakBlock); // <------ AVOIDING RETAIN CYCLE WITH A WEAK CAPTURE
        };
        weakBlock = mallocBlock;

        [center addObserverWithKey:key
                     observerOwner:owner
                     observerBlock:mallocBlock];

        [center postNotificationForKey:key
                                sender:nil
                              userInfo:nil];
    }
    XCTAssertNil(weakBlock);
    XCTAssertNil(weakOwner);
}

- (void)testSimpleApi {

    OKONotificationCentre *center = OKONotificationCentre.defaultCenter;

    for (CommonTestCase *testCase in self.testCases) {
        NSLog(@"%@",testCase.description);
        __weak NSObject *weakOwner = nil;
        __weak id weakBlock = nil;
        XCTestExpectation *exp = [self expectationWithDescription:testCase.description];
        exp.inverted = testCase.inverted;
        @autoreleasepool {
            NSObject *owner = [NSObject new];
            weakOwner = owner;
            id block = ^(id _Nullable sender, id _Nullable userInfo) {
                NSLog(@"Block called with sender: %@",[sender description]);
                XCTAssertEqual(sender, testCase);

                XCTAssertEqual(userInfo, testCase.postNotifInput.userInfo);

                XCTAssertNotNil(testCase.postNotifInput.name);

                [exp fulfill];
            };
            weakBlock = block;

            [center addObserverWithKey:testCase.addObseverInput.name
                         observerOwner:owner
                         observerBlock:block];

            [center postNotificationForKey:testCase.postNotifInput.name
                                    sender:testCase
                                  userInfo:testCase.postNotifInput.userInfo];
        }
        XCTAssertNil(weakBlock);
        XCTAssertNil(weakOwner);
        [self waitForExpectations:@[exp] timeout:1];
    }


}

- (void)testAddObserver {
    [super _testAddObserver];
}
- (void)testRemoveObserver {
    [super _testRemoveObserver];
}
- (void)testRemoveObserverNameObject {
    [super _testRemoveObserverNameObject];
}
- (void)testAddObserverObjectQueueUsingBlock {
    [super _testAddObserverObjectQueueUsingBlock];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
