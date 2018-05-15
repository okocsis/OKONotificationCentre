//
//  OKOMutableWeakArray.m
//  McK.HERO.Demo
//
//  Created by Oliver Kocsis on 2015. 07. 07..
//  Copyright (c) 2015. Oliver Kocsis. All rights reserved.
//

#import "OKOWeakMutableArray.h"
#import "OKOWeakArrayElementContainer.h"

NS_ASSUME_NONNULL_BEGIN
@interface OKOWeakMutableArray<ObjectType> ()

@property (nonatomic, strong) NSMutableArray<OKOWeakArrayElementContainer *> *backingArray;

@end

@implementation OKOWeakMutableArray

#pragma mark - Helpers
+ (OKOWeakArrayElementContainer *)_wrap:(id)anObject
                                  array:(NSMutableArray<OKOWeakArrayElementContainer *> *)array {
    NSParameterAssert(anObject);
    return [[OKOWeakArrayElementContainer alloc] initWithWeakElement:anObject
                                                               array:array];
}

+ (id)_unWrap:(OKOWeakArrayElementContainer *)elementContainer {
    NSAssert(elementContainer.weakElement != nil,
             @"Internal inconsistency. _unWrap should never return nil. All nil elements should be autoremoved");
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

- (instancetype)initWithObjects:(const id _Nonnull [_Nullable])objects
                          count:(NSUInteger)cnt  {
    self = [super init];
    if (self) {
        self.backingArray = [[NSMutableArray alloc] initWithCapacity:cnt];
        for (NSUInteger i = 0; i < cnt; ++i) {
            [self.backingArray addObject:[self.class _wrap:objects[i]
                                                     array:self.backingArray]];
        }
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    self = [super init];
    if (self) {
        self.backingArray = [[NSMutableArray alloc] initWithCapacity:numItems];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    NSAssert(false, @"-initWithCoder should not be used with this class");
    return nil;
}

- (id)objectAtIndex:(NSUInteger)index {
    return [self.class _unWrap:self.backingArray[index]];
}

- (NSUInteger)count {
    return self.backingArray.count;
}

#pragma mark - NSMutableArray overrides
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    NSParameterAssert(anObject);
    if (anObject == nil) {
        return;
    }
    [self.backingArray insertObject:[self.class _wrap:anObject
                                                array:self.backingArray]
                            atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [self.backingArray removeObjectAtIndex:index];
}

- (void)addObject:(id)anObject {
    NSParameterAssert(anObject);
    if (anObject == nil) {
        return;
    }
    [self.backingArray addObject:[self.class _wrap:anObject
                                             array:self.backingArray]];
}

- (void)removeLastObject {
    [self.backingArray removeLastObject];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    NSParameterAssert(anObject);
    if (anObject == nil) {
        return;
    }
    self.backingArray[index] = [self.class _wrap:anObject
                                           array:self.backingArray];
}

- (NSString *)description {
    return self.backingArray.description;
}

@end

@implementation NSArray(OKOWeakMutableArrayFactory)

- (OKOWeakMutableArray *)oko_weakMutableCopy {
    return [[OKOWeakMutableArray alloc] initWithArray:self];
}

@end
NS_ASSUME_NONNULL_END
