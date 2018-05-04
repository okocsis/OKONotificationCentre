//
//  OKOMutableWeakArray.m
//  McK.HERO.Demo
//
//  Created by Kocsis Olivér on 2015. 07. 07..
//  Copyright (c) 2015. Kocsis Oliver. All rights reserved.
//

#import "OKOWeakMutableArray.h"
#import "OKOWeakArrayElementContainer.h"

NS_ASSUME_NONNULL_BEGIN
@interface OKOWeakMutableArray<ObjectType> ()

@property (nonatomic, strong) NSMutableArray<OKOWeakArrayElementContainer *> *backingArray;

@end

@implementation OKOWeakMutableArray

#pragma mark - Public API
- (void)compact {
    NSLog(@"++++ compact called");
    NSIndexSet * indexes =
        [self.backingArray indexesOfObjectsPassingTest:
         ^BOOL(OKOWeakArrayElementContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [self unWrap:obj] == nil;
        }];

    [self.backingArray removeObjectsAtIndexes:indexes];
}

- (void)removeNilObjects {
    [self compact];
}

#pragma mark - Helpers
- (OKOWeakArrayElementContainer *) wrap:(id) anObject {
    NSParameterAssert(anObject);
    return [[OKOWeakArrayElementContainer alloc] initWithWeakElement:anObject
                                                               array:self.backingArray];
}

- (nullable id) unWrap:(OKOWeakArrayElementContainer *) elementContainer {
    return elementContainer.weakElement;
}

#pragma mark - NSArray overrides

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backingArray = [NSMutableArray new];
    }
    return self;
}

- (nullable id)objectAtIndex:(NSUInteger)index {
    return [self unWrap:self.backingArray[index]];
}

- (NSUInteger)count {
    return self.backingArray.count;
}

#pragma mark - NSMutableArray overrides
- (void)insertObject:(nullable id)anObject atIndex:(NSUInteger)index {
    if (anObject == nil) {
        return;
    }
    [self.backingArray insertObject:[self wrap:anObject] atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [self.backingArray removeObjectAtIndex:index];
}

- (void)addObject:(nullable id)anObject {
    if (anObject == nil) {
        return;
    }
    [self.backingArray addObject:[self wrap:anObject]];
}

- (void)removeLastObject {
    [self.backingArray removeLastObject];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(nullable id)anObject {
    if (anObject == nil) {
        return;
    }
    self.backingArray[index] = [self wrap:anObject];
}

- (NSString *)description {
    return self.backingArray.description;
}
@end

NS_ASSUME_NONNULL_END

