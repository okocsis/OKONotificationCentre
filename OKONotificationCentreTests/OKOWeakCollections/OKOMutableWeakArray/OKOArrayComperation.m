//
//  OKOArrayComperation.m
//  OKONotificationCentreTests
//
//  Created by Oliver Kocsis on 2018. 05. 04..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import "OKOArrayComperation.h"

BOOL areTheyIdentical(NSArray *array1, NSArray *array2) {
    @autoreleasepool {
        if (array1 == nil && array2 == nil) {
            return YES;
        }
        if (array1 == nil || array2 == nil) {
            return NO;
        }
        NSEnumerator *enumerator1 = array1.objectEnumerator;
        NSEnumerator *enumerator2 = array2.objectEnumerator;
        id objectFromArray1 = nil;
        id objectFromArray2 = nil;

        while (true) {
            objectFromArray1 = enumerator1.nextObject;
            objectFromArray2 = enumerator2.nextObject;
            if (objectFromArray1 == nil && objectFromArray2 == nil) {
                break;
            } else if (objectFromArray1 != nil && objectFromArray2 != nil) {
                if (objectFromArray1 != objectFromArray2) {
                    return NO;
                }
                continue;
            } else if (objectFromArray1 == nil && objectFromArray2 != nil) {
                return NO;
            } else if (objectFromArray1 != nil && objectFromArray2 == nil) {
                return NO;
            } else {
                return NO;
            }
        }
    }
    return YES;
}

@interface OKOArrayComperation()

@property (nonatomic, strong) NSMutableArray<NSObject *> *regularMutableArray;

@end

@implementation OKOArrayComperation

- (void)setUp {
    [super setUp];
    self.regularMutableArray = [NSMutableArray new];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAreTheyIdentical {
    NSArray *testData =
        @[[NSObject new],
          [NSObject new],
          [NSObject new]];

    //regular array will hold the data strongly
    [self.regularMutableArray addObjectsFromArray:testData];

    XCTAssertFalse(areTheyIdentical(@[[NSObject new]], @[]));
    XCTAssertFalse(areTheyIdentical(@[], @[[NSObject new]]));
    XCTAssertFalse(areTheyIdentical(nil, @[]));
    XCTAssertFalse(areTheyIdentical(@[], nil));

    XCTAssertTrue(areTheyIdentical(nil, nil));
    XCTAssertTrue(areTheyIdentical(@[], @[]));
    XCTAssertTrue(areTheyIdentical(testData, testData));

    XCTAssertTrue(areTheyIdentical(self.regularMutableArray, testData));
    XCTAssertTrue(areTheyIdentical(testData, self.regularMutableArray));

    NSObject *added = [NSObject new];
    [self.regularMutableArray addObject:added];
    testData = [testData arrayByAddingObject:added];
    XCTAssertTrue(areTheyIdentical(testData,self.regularMutableArray));

    NSObject *insertedObj = [NSObject new];
    [self.regularMutableArray insertObject:insertedObj
                                   atIndex:1];
    testData = [testData arrayByAddingObject:insertedObj];
    XCTAssertFalse(areTheyIdentical(testData,self.regularMutableArray));
}

@end
