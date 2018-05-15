//
//  OKOWeakObjectContainer.m
//  CityMapperChallange
//
//  Created by Oliver Kocsis on 2018. 04. 19..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import "OKOWeakArrayElementContainer.h"

@interface OKOWeakArrayElementContainer()<OKODeallocMonitorObjectDelegate>

@property (nonatomic, nullable, weak) id weakElement;
@property (nonatomic, weak) NSMutableArray<OKOWeakArrayElementContainer *> *array;
@property (nonatomic, strong) OKODeallocMonitor *deallocMonitor;

@end

@implementation OKOWeakArrayElementContainer

- (nullable instancetype)init {
    NSAssert(false, @"-init should not be used with this class");
    return nil;
}

- (instancetype)initWithWeakElement:(id)weakElement
                              array:(NSMutableArray<OKOWeakArrayElementContainer *> *)array {
    NSParameterAssert(weakElement);
    NSParameterAssert(array);
    self = [super init];
    if (self) {
            self.weakElement = weakElement;
            self.deallocMonitor = [OKODeallocMonitor monitorWithObject:weakElement];
            self.deallocMonitor.delegate = self;
            self.array = array;
    }
    return self;
}

-(void)didDeallocMonitoredObject {
    [self removeYourself];
}

- (void)removeYourself {
    [self.array removeObject:self];
    self.array = nil;
}

@end
