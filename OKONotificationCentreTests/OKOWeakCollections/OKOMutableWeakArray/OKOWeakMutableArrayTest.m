//
//  OKOWeakMutableArrayTest.m
//  OKONotificationCentreTests
//
//  Created by Kocsis Olivér on 2018. 05. 02..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OKOWeakMutableArray.h"
#import "OKOArrayComperation.h"

@interface OKOWeakMutableArrayTest : XCTestCase

@property (nonatomic, strong) NSMutableArray<NSObject *> *regularMutableArray;
@property (nonatomic, strong) OKOWeakMutableArray<NSObject *> *weakMutableArray;

@end

@implementation OKOWeakMutableArrayTest

- (void)setUp {
    [super setUp];
    self.regularMutableArray = [NSMutableArray new];
    self.weakMutableArray = [OKOWeakMutableArray new];

}

- (void)tearDown {
    self.regularMutableArray = nil;
    self.weakMutableArray = nil;
    [super tearDown];
}


- (void)testAutoRemovalOnDeallocation {

    //regular array will hold the data strongly
    [self.regularMutableArray addObjectsFromArray:@[[NSObject new],
                                                    [NSObject new],
                                                    [NSObject new]]];
    [self.weakMutableArray addObjectsFromArray:self.regularMutableArray];

    XCTAssertTrue(areTheyIdentical(self.regularMutableArray, self.weakMutableArray));

    [self.regularMutableArray removeObjectAtIndex:1];
    XCTAssertTrue(areTheyIdentical(self.regularMutableArray, self.weakMutableArray));

    NSObject *obj = [NSObject new];
    NSObject *lastObjBeforAdding = self.weakMutableArray.lastObject;
    [self.weakMutableArray addObject:obj];
    @autoreleasepool {
        XCTAssertEqual(obj, self.weakMutableArray.lastObject);
    }
    obj = nil;

    XCTAssertEqual(lastObjBeforAdding,self.weakMutableArray.lastObject);

}

- (void)testInsert {
    [self.regularMutableArray addObjectsFromArray:@[[NSObject new],
                                                    [NSObject new],
                                                    [NSObject new]]];
    [self.weakMutableArray addObjectsFromArray:self.regularMutableArray];

    XCTAssertThrowsSpecificNamed([self.weakMutableArray insertObject:nil
                                                             atIndex:1],
                                 NSException,
                                 NSInternalInconsistencyException);
    XCTAssertTrue(areTheyIdentical(self.regularMutableArray, self.weakMutableArray));

    @autoreleasepool {
        NSObject *newObject = [NSObject new];
        [self.weakMutableArray insertObject:newObject
                                    atIndex:1];
        XCTAssertEqual(self.weakMutableArray.count, 4);
        XCTAssertEqual(newObject, self.weakMutableArray[1]);
    }
    XCTAssertTrue(areTheyIdentical(self.regularMutableArray, self.weakMutableArray));
}

- (void)testRemove {
    [self.regularMutableArray addObjectsFromArray:@[[NSObject new],
                                                    [NSObject new],
                                                    [NSObject new],
                                                    [NSObject new],
                                                    [NSObject new],
                                                    [NSObject new]]];

    [self.weakMutableArray addObjectsFromArray:self.regularMutableArray];
    NSUInteger count = self.weakMutableArray.count;

    [self.weakMutableArray removeObjectAtIndex:1];
    XCTAssertEqual(self.weakMutableArray.count, --count);

    [self.regularMutableArray removeObjectAtIndex:1];
    XCTAssertTrue(areTheyIdentical(self.weakMutableArray, self.regularMutableArray));

    for (NSInteger i = count; i >= 0-1; --i) {
        [self.weakMutableArray removeLastObject];
        count = count > 0 ? count - 1 : 0;
        XCTAssertEqual(self.weakMutableArray.count, count);

        [self.regularMutableArray removeLastObject];
        XCTAssertTrue(areTheyIdentical(self.weakMutableArray, self.regularMutableArray));
    }

    XCTAssertEqual(self.regularMutableArray.count, 0);
    XCTAssertEqual(self.weakMutableArray.count, 0);
    NSObject *addedObject = [NSObject new];
    [self.regularMutableArray addObject:addedObject];
    [self.weakMutableArray addObject:addedObject];

    [self.weakMutableArray removeObject:[NSObject new]];
    XCTAssertEqual(self.weakMutableArray.count, 1);

    [self.weakMutableArray removeObject:addedObject];
    XCTAssertEqual(self.weakMutableArray.count, 0);

    [self.regularMutableArray removeObject:addedObject];
    XCTAssertEqual(self.regularMutableArray.count, 0);

}

- (void)testLastObject {
    [self.regularMutableArray addObjectsFromArray:@[[NSObject new],
                                                    [NSObject new]]];
    [self.weakMutableArray addObjectsFromArray:self.regularMutableArray];

    for (NSInteger i = self.weakMutableArray.count; i >= 0; --i) {
        @autoreleasepool {
            NSObject *objectFromWeak = self.weakMutableArray.lastObject;
            NSObject *objectFromReg = self.regularMutableArray.lastObject;
            XCTAssertEqual(objectFromWeak, objectFromReg);
            [self.regularMutableArray removeLastObject];
        }
    }
    XCTAssertEqual(self.weakMutableArray.count, 0);
    XCTAssertNil(self.weakMutableArray.lastObject);
}

- (void)testLastObject2 {
    [self.regularMutableArray addObjectsFromArray:@[[NSObject new],
                                                    [NSObject new]]];
    [self.weakMutableArray addObjectsFromArray:self.regularMutableArray];

    for (NSInteger i = self.weakMutableArray.count; i >= 0; --i) {
        NSObject *objectFromWeak = self.weakMutableArray.lastObject;
        NSObject *objectFromReg = self.regularMutableArray.lastObject;
        XCTAssertEqual(objectFromWeak, objectFromReg);
        [self.weakMutableArray removeLastObject];
        [self.regularMutableArray removeLastObject];
    }
    XCTAssertEqual(self.weakMutableArray.count, 0);
    XCTAssertNil(self.weakMutableArray.lastObject);
}

- (void)testReplace {
    [self.regularMutableArray addObjectsFromArray:@[[NSObject new],
                                                    [NSObject new],
                                                    [NSObject new]]];
    [self.weakMutableArray addObjectsFromArray:self.regularMutableArray];

    NSObject *before = self.weakMutableArray[1];

    XCTAssertThrowsSpecificNamed([self.weakMutableArray replaceObjectAtIndex:1
                                                                  withObject:nil],
                                 NSException,
                                 NSInternalInconsistencyException);
    NSObject *after = self.weakMutableArray[1];
    XCTAssertEqual(before, after);

    @autoreleasepool {
        NSObject *newObject = [NSObject new];
        self.weakMutableArray[1] = newObject;
        XCTAssertEqual(newObject, self.weakMutableArray[1]);
    }

}

- (void)testInitWithObjects {
    [self.regularMutableArray addObjectsFromArray:@[[NSObject new],
                                                    [NSObject new],
                                                    [NSObject new]]];
    // arrayWithArray triggers initWithObjects
    OKOWeakMutableArray *arrayCopy = [OKOWeakMutableArray arrayWithArray:self.regularMutableArray];
    XCTAssertNotEqual(arrayCopy, self.regularMutableArray);
    @autoreleasepool {
        [self.weakMutableArray addObjectsFromArray:self.regularMutableArray];

        XCTAssertEqual(arrayCopy.count, self.regularMutableArray.count);
        XCTAssertEqual(self.weakMutableArray.count, self.regularMutableArray.count);
        XCTAssert(areTheyIdentical(arrayCopy, self.regularMutableArray));
        XCTAssert(areTheyIdentical(self.weakMutableArray, self.regularMutableArray));

        [self.regularMutableArray removeLastObject];
    }

    XCTAssertEqual(arrayCopy.count, self.regularMutableArray.count);
    XCTAssertEqual(self.weakMutableArray.count, self.regularMutableArray.count);
    XCTAssert(areTheyIdentical(arrayCopy, self.regularMutableArray));
    XCTAssert(areTheyIdentical(self.weakMutableArray, self.regularMutableArray));
}

- (void)testWeakMutableCopy {
    [self.regularMutableArray addObjectsFromArray:@[[NSObject new],
                                                    [NSObject new],
                                                    [NSObject new]]];
    // arrayWithArray triggers initWithObjects
    OKOWeakMutableArray *arrayCopy = self.regularMutableArray.oko_weakMutableCopy;
    XCTAssertNotEqual(arrayCopy, self.regularMutableArray);
    @autoreleasepool {
        [self.weakMutableArray addObjectsFromArray:self.regularMutableArray];

        XCTAssertEqual(arrayCopy.count, self.regularMutableArray.count);
        XCTAssertEqual(self.weakMutableArray.count, self.regularMutableArray.count);
        XCTAssert(areTheyIdentical(arrayCopy, self.regularMutableArray));
        XCTAssert(areTheyIdentical(self.weakMutableArray, self.regularMutableArray));

        [self.regularMutableArray removeLastObject];
    }

    XCTAssertEqual(arrayCopy.count, self.regularMutableArray.count);
    XCTAssertEqual(self.weakMutableArray.count, self.regularMutableArray.count);
    XCTAssert(areTheyIdentical(arrayCopy, self.regularMutableArray));
    XCTAssert(areTheyIdentical(self.weakMutableArray, self.regularMutableArray));
}

- (void)testNSCoding {
    [self.regularMutableArray addObjectsFromArray:@[[NSMutableString stringWithFormat:@"0"],
                                                    [NSMutableString stringWithFormat:@"1"],
                                                    [NSMutableString stringWithFormat:@"2"]]];
    NSData *data =
        [NSKeyedArchiver archivedDataWithRootObject:self.regularMutableArray];
    NSMutableArray *retrievedMutableArray =
        [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssert([retrievedMutableArray isEqualToArray:self.regularMutableArray]);

    [self.weakMutableArray addObjectsFromArray:self.regularMutableArray];

    NSData *dataFromWeakArray =
        [NSKeyedArchiver archivedDataWithRootObject:self.weakMutableArray];
    NSMutableArray *retrievedMutableArray2 =
        [NSKeyedUnarchiver unarchiveObjectWithData:dataFromWeakArray];
    XCTAssert([retrievedMutableArray2 isEqualToArray:self.weakMutableArray]);

    NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataFromWeakArray];

    XCTAssertThrowsSpecificNamed([(id)[OKOWeakMutableArray alloc] initWithCoder:decoder],
                                 NSException,
                                 NSInternalInconsistencyException);

}

@end
