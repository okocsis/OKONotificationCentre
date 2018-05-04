
#import "CommonNotificationCentreTests.h"
NS_ASSUME_NONNULL_BEGIN
@interface CommonObserver : NSObject
@property (nonatomic, strong) void (^didRecieveNotification)(NSNotification *notif);
- (void)didRecieveNotification:(NSNotification *) notif;
@end
@implementation CommonObserver
- (void)didRecieveNotification:(NSNotification *) notif {

}
@end

@interface CommonNotificationCentreTests()

@property (nonatomic, strong) id<CommonNotificationCenter> center;

@end
NS_ASSUME_NONNULL_END

@implementation CommonNotificationCentreTests

- (id<CommonNotificationCenter>)defaultCenter {
    XCTFail();
    return nil; // abstract
}


- (void)setUp {
    [super setUp];
    self.center = [self defaultCenter];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAddObserver {


}
- (void)testPostNotification {

}
- (void)testPostNotificationNameObject {

}
- (void)testPostNotificationNameObjectUserInfo {

}
- (void)testRemoveObserver {

}
- (void)testRemoveObserverNameObject {

}
- (void)testAddObserverObjectQueueUsingBlock {

}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
