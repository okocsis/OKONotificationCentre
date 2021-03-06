//
//  OKOAssociatedWeakArrayTest.m
//  OKONotificationCentreTests
//
//  Created by Oliver Kocsis on 2018. 05. 04..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import <XCTest/XCTest.h>
@import OKONotificationCentre;
#import "OKOArrayComperation.h"

@interface OKOAssociatedWeakArrayTest : XCTestCase

@property (nonatomic, strong) NSMutableArray<NSObject *> *stronglyHoldedObjects;
@property (nonatomic, strong) OKOAssociatedWeakMutableArray<NSObject *> *associatedWeakMutableArray;

@end

@implementation OKOAssociatedWeakArrayTest

- (void)setUp {
    [super setUp];
    self.stronglyHoldedObjects = [NSMutableArray new];
    self.associatedWeakMutableArray = [OKOAssociatedWeakMutableArray new];
}

- (void)tearDown {
    self.stronglyHoldedObjects = nil;
    self.associatedWeakMutableArray = nil;
    [super tearDown];
}

- (void)testAutoRemovalOnDeallocation1 {
//    @autoreleasepool {
    [self.stronglyHoldedObjects addObjectsFromArray:@[[NSObject new],
                                                      [NSObject new],
                                                      [NSObject new]]];
    for (int i = 0; i < self.stronglyHoldedObjects.count; ++i) {
        __block NSObject *object = [NSObject new];
        id block = ^{ return object; };
        [self.associatedWeakMutableArray addObject:block
                                   associatedOwner:self.stronglyHoldedObjects[i]];
    }
    XCTAssertEqual(self.associatedWeakMutableArray.count, self.stronglyHoldedObjects.count);

    while (self.stronglyHoldedObjects.lastObject != nil) {
        [self.stronglyHoldedObjects removeLastObject];
        XCTAssertEqual(self.associatedWeakMutableArray.count, self.stronglyHoldedObjects.count);
    }
    XCTAssertEqual(self.associatedWeakMutableArray.count, self.stronglyHoldedObjects.count);
}

- (void)testAutoRemovalOnDeallocation2 {
    __weak NSObject *weakObj = nil;
    NSObject *owner = nil;
    @autoreleasepool {
        owner = [NSObject new];
        NSObject *obj = [NSObject new];
        [self.associatedWeakMutableArray addObject:obj
                                   associatedOwner:owner];
        weakObj = obj;
    }
    XCTAssertNotNil(weakObj);
    XCTAssertEqual(self.associatedWeakMutableArray.count, 1);
    owner = nil;
    XCTAssertEqual(self.associatedWeakMutableArray.count, 0);
    XCTAssertNil(weakObj);

}
- (void)testAutoRemovalOnDeallocation3 {
    NSObject *owner = [NSObject new];
    [self.associatedWeakMutableArray addObject:^{}
                               associatedOwner:owner];
    XCTAssertEqual(self.associatedWeakMutableArray.count, 1);
    owner = nil;
    XCTAssertEqual(self.associatedWeakMutableArray.count, 0);
}

- (void)testAutoRemovalOnDeallocation4 {
    __weak NSObject *weakOwner = nil;
    @autoreleasepool {
        NSObject *owner = [NSObject new];
        weakOwner = owner;
        __weak typeof(owner) weakOwner = owner;
        [self.associatedWeakMutableArray addObject:^{ return owner;}
                                   associatedOwner:owner];
        XCTAssertEqual(self.associatedWeakMutableArray.count, 1);
        owner = nil;
        // retain cycle because of the strongly captured owner
        XCTAssertEqual(self.associatedWeakMutableArray.count, 1);
        XCTAssertNotNil(weakOwner);
        [self.associatedWeakMutableArray removeLastObject];
        XCTAssertEqual(self.associatedWeakMutableArray.count, 0);
    }
    XCTAssertNil(weakOwner);

}

- (void)testAutoRemovalOnDeallocation5 {
    NSObject *owner = [NSObject new];
    __weak typeof(owner) weakOwner = owner;
    [self.associatedWeakMutableArray addObject:^{ return weakOwner;}
                               associatedOwner:owner];
    XCTAssertEqual(self.associatedWeakMutableArray.count, 1);
    owner = nil;
    XCTAssertEqual(self.associatedWeakMutableArray.count, 0);
}

- (void)testAutoRemovalOnDeallocation6 {
    NSObject *owner = [NSObject new];
    [self.associatedWeakMutableArray addObject:@"hello"
                               associatedOwner:owner];
    XCTAssertEqual(self.associatedWeakMutableArray.count, 1);
    owner = nil;
    XCTAssertEqual(self.associatedWeakMutableArray.count, 0);
}

- (void)testRemoveAtIndex {
    NSObject *owner = [NSObject new];
    NSObject *object = [NSObject new];
    __weak NSObject *weakObject = object;
    [self.associatedWeakMutableArray addObject:object
                               associatedOwner:owner];
    object = nil;
    XCTAssertEqual(self.associatedWeakMutableArray.count, 1);
    XCTAssertNotNil(weakObject);

    [self.associatedWeakMutableArray removeObjectAtIndex:0];
    XCTAssertEqual(self.associatedWeakMutableArray.count, 0);
    XCTAssertNil(weakObject);

}

- (void)testIndexOfObject {
    NSObject *owner = [NSObject new];
    NSObject *object = [NSObject new];
    __weak NSObject *weakObject = object;
    [self.associatedWeakMutableArray addObject:object
                               associatedOwner:owner];
    object = nil;

    XCTAssertEqual([self.associatedWeakMutableArray indexOfObject:[NSObject new]], NSNotFound);
    XCTAssertEqual([self.associatedWeakMutableArray indexOfObject:weakObject], 0);
}

- (void)testRemoveObject {
    NSObject *owner = [NSObject new];
    NSObject *object = [NSObject new];
    __weak NSObject *weakObject = object;
    [self.associatedWeakMutableArray addObject:object
                               associatedOwner:owner];
    object = nil;
    XCTAssertEqual(self.associatedWeakMutableArray.count, 1);
    XCTAssertNotNil(weakObject);

    [self.associatedWeakMutableArray removeObject:[NSObject new]];
    XCTAssertEqual(self.associatedWeakMutableArray.count, 1);

    [self.associatedWeakMutableArray removeObject:nil];
    XCTAssertEqual(self.associatedWeakMutableArray.count, 1);


    [self.associatedWeakMutableArray removeObject:weakObject];
    XCTAssertEqual(self.associatedWeakMutableArray.count, 0);
    XCTAssertNil(weakObject);

}

- (void)testRemoveObjectsAtIndexes {
    __weak NSObject *weakObject = nil;
    __weak NSObject *weakObject2 = nil;
    __weak NSObject *weakObject3 = nil;
    __weak NSObject *weakOwner = nil;
    @autoreleasepool {
        NSObject *owner = nil;

        @autoreleasepool {
            owner = [NSObject new];
            weakOwner = owner;
            NSObject *object = [NSObject new];
            NSObject *object2 = [NSObject new];
            NSObject *object3 = [NSObject new];
            weakObject = object;
            weakObject2 = object2;
            weakObject3 = object3;

            [self.associatedWeakMutableArray addObject:object
                                       associatedOwner:owner];
            [self.associatedWeakMutableArray addObject:object2
                                       associatedOwner:owner];
            [self.associatedWeakMutableArray addObject:object3
                                       associatedOwner:owner];
            object = nil;
            object2 = nil;
            object3 = nil;
        }
        XCTAssertEqual(self.associatedWeakMutableArray.count, 3);
        XCTAssertNotNil(weakObject);
        XCTAssertNotNil(weakObject2);
        XCTAssertNotNil(weakObject3);

        NSIndexSet *indexes =
            [self.associatedWeakMutableArray indexesOfObjectsPassingTest:^BOOL(NSObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return (obj == weakObject) || (obj == weakObject3);
            }];
        [self.associatedWeakMutableArray removeObjectsAtIndexes:indexes];

        XCTAssertEqual(self.associatedWeakMutableArray.count, 1);
        XCTAssertNil(weakObject);
        XCTAssertNotNil(weakObject2);
        XCTAssertNil(weakObject3);
        XCTAssertEqual(self.associatedWeakMutableArray[0], weakObject2);

        owner = nil;
    }
    XCTAssertNil(weakOwner);
    XCTAssertNil(weakObject2);
    XCTAssertEqual(self.associatedWeakMutableArray.count, 0);
}

- (void)testDealloc {
    __weak NSObject *weakObj = nil;
    NSObject *owner = nil;
    __weak NSObject *weakOwner = nil;
    OKOAssociatedWeakMutableArray *associatedWeakMutableArray = nil;
    __weak OKOAssociatedWeakMutableArray *weakAssociatedWeakMutableArray = nil;
    @autoreleasepool {
        associatedWeakMutableArray = [OKOAssociatedWeakMutableArray new];
        weakAssociatedWeakMutableArray = associatedWeakMutableArray;
        owner = [NSObject new];
        weakOwner = owner;
        NSObject *obj = [NSObject new];
        [associatedWeakMutableArray addObject:obj
                              associatedOwner:owner];
        weakObj = obj;
        XCTAssertEqual(associatedWeakMutableArray.count, 1);
    }
    XCTAssertNotNil(weakObj);

    associatedWeakMutableArray = nil;
    XCTAssertNil(weakObj);

    owner = nil;
    XCTAssertNil(weakOwner);
}

@end
