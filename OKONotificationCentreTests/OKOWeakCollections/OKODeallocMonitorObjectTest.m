//
//  OKODeallocMonitorObjectTest.m
//  OKONotificationCentreTests
//
//  Created by Oliver Kocsis on 2018. 04. 30..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import <XCTest/XCTest.h>
@import OKONotificationCentre;

NS_ASSUME_NONNULL_BEGIN
@interface MonitorDelegate : NSObject<OKODeallocMonitorObjectDelegate>

@property (nonatomic, strong) void(^didDeallock)(void);

@end

@implementation MonitorDelegate

- (void)didDeallocMonitoredObject {
    self.didDeallock();
}

@end

@interface OKODeallocMonitorObjectTest : XCTestCase

@property (nonatomic, nullable, strong) NSObject *monitoredObject1;
@property (nonatomic, nullable, strong) NSObject *monitoredObject2;

@property (nonatomic, nullable, strong) OKODeallocMonitor *deallocMonitor;

@end
NS_ASSUME_NONNULL_END

@implementation OKODeallocMonitorObjectTest

#pragma mark - test
- (void)setUp {
    [super setUp];
    self.monitoredObject1 = nil;
    self.monitoredObject2 = nil;
    self.deallocMonitor = nil;
}
- (void)tearDown {
    self.monitoredObject1 = nil;
    self.monitoredObject2 = nil;
    self.deallocMonitor = nil;
    [super tearDown];
}

- (void)test {
//------------Testing simple test-----------
    XCTestExpectation *simpleTest =
        [self expectationWithDescription:@"simpleTest"];
    self.monitoredObject1 = [NSObject new];
    self.monitoredObject2 = [NSObject new];
    self.deallocMonitor =
        [OKODeallocMonitor monitorWithObject:self.monitoredObject1];
    MonitorDelegate *delegate = [MonitorDelegate new];

    delegate.didDeallock = ^{
        [simpleTest fulfill];
    };
    self.deallocMonitor.delegate = delegate;

    self.monitoredObject1 = nil; // <------ causes ARC to do the magic

    [self waitForExpectations:@[simpleTest]
                      timeout:1];

//------------Testing reusing an empty monitor-----------
    XCTestExpectation *registeringAnotherObject =
        [self expectationWithDescription:@"registeringAnotherObject"];

    delegate = [MonitorDelegate new];

    delegate.didDeallock = ^{
        [registeringAnotherObject fulfill];
    };
    self.deallocMonitor.delegate = delegate;
    [self.deallocMonitor registerMonitoredObject:self.monitoredObject2];
    self.monitoredObject2 = nil; // <------ causes ARC to do the magic

    [self waitForExpectations:@[registeringAnotherObject]
                      timeout:1];

//------------Testing object replace-----------
    XCTestExpectation *shouldNotBeFulfilled =
        [self expectationWithDescription:@"shouldNotBeFulfilled"];
    shouldNotBeFulfilled.inverted = YES;

    delegate = [MonitorDelegate new];
    self.monitoredObject1 = [NSObject new];
    self.monitoredObject2 = [NSObject new];

    delegate.didDeallock = ^{
        [shouldNotBeFulfilled fulfill];
    };
    self.deallocMonitor.delegate = delegate;

    [self.deallocMonitor registerMonitoredObject:self.monitoredObject1];
    // causing it to not monitor old object (monitoredObject1) any more but only the new one (monitoredObject2)
    [self.deallocMonitor registerMonitoredObject:self.monitoredObject2];
    // this should *not* triggger the deallocMonitors delegate
    self.monitoredObject1 = nil; // <------ causes ARC to do the magic

    XCTestExpectation *shouldBeFulfilled =
        [self expectationWithDescription:@"shouldBeFulfilled"];    shouldNotBeFulfilled.inverted = YES;
    delegate = [MonitorDelegate new];

    delegate.didDeallock = ^{
        [shouldBeFulfilled fulfill];
    };
    self.deallocMonitor.delegate = delegate;
    // this should indeed trigger the delegate since monitoredObject2 is the the new monitored object
    self.monitoredObject2 = nil; // <------ causes ARC to do the magic

    [self waitForExpectations:@[shouldNotBeFulfilled, shouldBeFulfilled]
                      timeout:1
                 enforceOrder:YES];
}

- (void)testNil {
    XCTestExpectation *shouldNotFulfill =
        [self expectationWithDescription:@"nil_shouldFulfill"];
    shouldNotFulfill.inverted = YES;
    self.deallocMonitor =
        [OKODeallocMonitor monitorWithObject:nil];
    MonitorDelegate *delegate = [MonitorDelegate new];

    delegate.didDeallock = ^{
        [shouldNotFulfill fulfill];
    };
    self.deallocMonitor.delegate = delegate;

    [self waitForExpectations:@[shouldNotFulfill]
                      timeout:1];
}

- (void)testNil2 {
    XCTestExpectation *shouldNotFulfill1 =
        [self expectationWithDescription:@"nil2_shouldNotFulfill1"];
    shouldNotFulfill1.inverted = YES;
    XCTestExpectation *shouldNotFulfill2 =
        [self expectationWithDescription:@"nil2_shouldNotFulfill2"];
    shouldNotFulfill2.inverted = YES;

    self.monitoredObject1 = [NSObject new];
    self.deallocMonitor =
        [OKODeallocMonitor monitorWithObject:self.monitoredObject1 ];
    MonitorDelegate *delegate = [MonitorDelegate new];

    delegate.didDeallock = ^{
        [shouldNotFulfill2 fulfill];
    };
    self.deallocMonitor.delegate = delegate;

    [self.deallocMonitor registerMonitoredObject:nil];
    self.monitoredObject1 = nil;

    delegate = [MonitorDelegate new];

    delegate.didDeallock = ^{
        [shouldNotFulfill2 fulfill];
    };
    self.deallocMonitor.delegate = delegate;

    [self waitForExpectations:@[shouldNotFulfill1, shouldNotFulfill2]
                      timeout:1
                 enforceOrder:YES];
}

- (void)testNil3 {
    XCTestExpectation *shouldFulfill1 =
    [self expectationWithDescription:@"nil3_shouldNotFulfill1"];
    XCTestExpectation *shouldNotFulfill2 =
    [self expectationWithDescription:@"nil3_shouldNotFulfill2"];
    shouldNotFulfill2.inverted = YES;

    self.monitoredObject1 = [NSObject new];
    self.deallocMonitor =
    [OKODeallocMonitor monitorWithObject:self.monitoredObject1 ];
    MonitorDelegate *delegate = [MonitorDelegate new];

    delegate.didDeallock = ^{
        [shouldFulfill1 fulfill];
    };
    self.deallocMonitor.delegate = delegate;
    self.monitoredObject1 = nil;

    [self.deallocMonitor registerMonitoredObject:nil];

    delegate = [MonitorDelegate new];

    delegate.didDeallock = ^{
        [shouldNotFulfill2 fulfill];
    };
    self.deallocMonitor.delegate = delegate;

    [self waitForExpectations:@[shouldFulfill1, shouldNotFulfill2]
                      timeout:1
                 enforceOrder:YES];
}

@end
