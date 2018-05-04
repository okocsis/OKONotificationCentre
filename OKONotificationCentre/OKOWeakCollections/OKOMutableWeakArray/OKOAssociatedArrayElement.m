//
//  OKOWeakObject.m
//  CityMapperChallange
//
//  Created by Kocsis Olivér on 2018. 04. 19..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import "OKOAssociatedArrayElement.h"

NS_ASSUME_NONNULL_BEGIN
@interface OKOAssociatedArrayElement() <OKODeallocMonitorObjectDelegate>

@property (nonatomic, nullable, strong) id ownedObject;
@property (nonatomic, strong) OKOWeakArrayElementContainer *container;
@property (nonatomic, nullable, strong) OKODeallocMonitor *deallocMonitor;


@end
@implementation OKOAssociatedArrayElement

-(instancetype)initWithObject:(nullable id)object
                        array:(NSMutableArray *) array
              associatedOwner:(NSObject *) associatedOwner {
    self = [super init];
    if (self) {
        self.ownedObject = object;
        OKOWeakArrayElementContainer * container =
            [[OKOWeakArrayElementContainer alloc] initWithWeakElement:self
                                                                array:array];
        self.container = container;

        self.deallocMonitor = [[OKODeallocMonitor alloc] initWithMonitoredObject:associatedOwner];
        self.deallocMonitor.delegate = self;

    }
    return self;
}

#pragma mark - OKODeallocMonitorObjectDelegate

- (void)didDeallocMonitoredObject {
    [self removeYourself];
}

#pragma mark - Public

- (void)removeYourself {
    [self.container removeYourself];
}

@end
NS_ASSUME_NONNULL_END
