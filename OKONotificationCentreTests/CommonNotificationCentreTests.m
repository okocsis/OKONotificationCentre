
#import "CommonNotificationCentreTests.h"

NS_ASSUME_NONNULL_BEGIN
@interface CommonObserver : NSObject

@property (nonatomic, weak) id<CommonNotificationCenter> center;
@property (nonatomic, strong) void (^didRecieveNotification)(NSNotification *notif);
@property (nonatomic, strong) void (^didDealloc)(void);
@property (nonatomic, strong) NSString *description;

- (void)didRecieveNotification:(NSNotification *) notif;

@end

@implementation CommonObserver
@synthesize description = _description;

- (void)didRecieveNotification:(NSNotification *) notif {
    self.didRecieveNotification(notif);
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ object: %@",_description, super.description];
}

-(void)dealloc {
//    [self.center removeObserver:self];
    self.didDealloc();
}

@end

@interface CommonNotificationCentreTests()

@property (nonatomic, strong) id<CommonNotificationCenter> center;
@property (nonatomic, readonly) NSArray<CommonTestCase *> *testCases;

@end

@implementation CommonNotificationCentreTests

- (id<CommonNotificationCenter>)defaultCenter {
    XCTFail();
    return nil; // abstract
}

- (NSArray<CommonTestCase *> *)testCases {
    return @[
             [CommonTestCase caseWithDesc:@"test 0"
                         addObserverInput:[AddObserverInput inputWithName:nil
                                                                   object:nil]
                           postNotifInput:[PostNotifInput inputWithName:@"OKOTest_someName"
                                                                 object:nil
                                                               userInfo:nil]
                                 inverted:NO],
             [CommonTestCase caseWithDesc:@"test 1"
                         addObserverInput:[AddObserverInput inputWithName:@"OKOTest_sameName"
                                                                   object:nil]
                           postNotifInput:[PostNotifInput inputWithName:@"OKOTest_sameName"
                                                                 object:nil
                                                               userInfo:nil]
                                 inverted:NO],
             [CommonTestCase caseWithDesc:@"test 2"
                         addObserverInput:[AddObserverInput inputWithName:@"OKOTest_sameName"
                                                                   object:nil]
                           postNotifInput:[PostNotifInput inputWithName:@"OKOTest_differentName"
                                                                 object:nil
                                                               userInfo:nil]
                                 inverted:YES]

             ];
}


- (void)setUp {
    [super setUp];
    self.center = [self defaultCenter];
}

- (void)tearDown {
    [super tearDown];
}

- (void)_testAddObserver {

    for (CommonTestCase *testCase in self.testCases) {
        XCTestExpectation *deallocExp = [self expectationWithDescription:@"deallocExpectation"];
        @autoreleasepool {
            NSLog(@"%@",testCase.description);
            CommonObserver *observer = [CommonObserver new];
            observer.description = testCase.description;
            observer.center = self.center;
            XCTestExpectation *exp = [self expectationWithDescription:testCase.description];
            exp.inverted = testCase.inverted;
            __weak typeof(observer) weakObserver = observer;
            observer.didRecieveNotification = ^(NSNotification * _Nonnull notif) {
                if ([notif.name hasPrefix:@"OKOTest"] == NO) {
                    NSLog(@"Ignoring CocoaNotification named: %@ from queue: %@ thead: %@",
                          notif.name,
                          @(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)),
                          NSThread.currentThread.debugDescription);
                    return;
                }

                XCTAssertNotNil(notif);
                XCTAssertEqual(notif.userInfo, testCase.postNotifInput.userInfo);

                XCTAssertNotNil(testCase.postNotifInput.name);
                XCTAssertEqualObjects(notif.name, testCase.postNotifInput.name);
                if (testCase.addObseverInput.name != nil) {
                    XCTAssertEqualObjects(notif.name, testCase.addObseverInput.name);
                }

                if (testCase.postNotifInput.object != nil) {
                    XCTAssertEqualObjects(notif.object, testCase.postNotifInput.object);
                }
                if (testCase.addObseverInput.object != nil) {
                    XCTAssertEqualObjects(notif.object, testCase.addObseverInput.object);
                }

                [exp fulfill];
                NSLog(@"%@",weakObserver.description);

            };
            observer.didDealloc = ^{
                [deallocExp fulfill];
            };
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
                NSLog(@"background log %@ from queue: %@ thead: %@",
                      observer.description,
                      @(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)),
                      NSThread.currentThread.debugDescription);
            });
            [self.center addObserver:observer
                            selector:@selector(didRecieveNotification:)
                                name:testCase.addObseverInput.name
                              object:testCase.addObseverInput.object];

            [self.center postNotificationName:testCase.postNotifInput.name
                                       object:testCase.postNotifInput.object
                                     userInfo:testCase.postNotifInput.userInfo];
            [self waitForExpectations:@[exp] timeout:1];
        }
        [self waitForExpectations:@[deallocExp] timeout:2];

    }

}


- (void)_testRemoveObserver {

}
- (void)_testRemoveObserverNameObject {

}
- (void)_testAddObserverObjectQueueUsingBlock {

}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
NS_ASSUME_NONNULL_END
