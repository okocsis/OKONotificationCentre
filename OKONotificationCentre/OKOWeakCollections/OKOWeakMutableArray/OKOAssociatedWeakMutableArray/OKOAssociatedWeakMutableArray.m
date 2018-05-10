//
//  OKOAssociatedMutableArray.m
//  CityMapperChallange
//
//  Created by Kocsis Olivér on 2018. 04. 23..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import "OKOAssociatedWeakMutableArray.h"
#import "OKOWeakMutableArray.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN
@interface OKOAssociatedWeakArrayElement : NSObject

@property (nonatomic, strong) id ownedObject;
@property (nonatomic, nullable, weak) id owner;
- (void)nilOwnedObject;

@end

@implementation OKOAssociatedWeakArrayElement

- (id)ownedObject {
    NSParameterAssert(_ownedObject);
    return _ownedObject;
}

- (void)nilOwnedObject {
    _ownedObject = nil;
}

@end

@interface OKOAssociatedWeakMutableArray ()
@property (nonatomic, strong) OKOWeakMutableArray<OKOAssociatedWeakArrayElement *> *backingWeakArray;
@end

@implementation OKOAssociatedWeakMutableArray

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backingWeakArray = [OKOWeakMutableArray new];
    }
    return self;
}



- (OKOAssociatedWeakArrayElement *) _wrapObject:(id)anObject
                               andAssociateWith:(NSObject *)associatedOwner {
        OKOAssociatedWeakArrayElement *element = [OKOAssociatedWeakArrayElement new];
        element.ownedObject = anObject;
        element.owner = associatedOwner;

        const void *key = (__bridge const void * _Nonnull)(element);
        objc_setAssociatedObject(associatedOwner, key, element, OBJC_ASSOCIATION_RETAIN);

        return element;
}

- (nullable id)_unWrap:(OKOAssociatedWeakArrayElement *)element {
    return element.ownedObject;
}



- (void)_disassociate:(nullable OKOAssociatedWeakArrayElement *)element {
    if (element == nil || element.owner == nil) {
        return;
    }
    id owner = element.owner;
    const void *key = (__bridge const void * _Nonnull)(element);
    objc_setAssociatedObject(owner, key, nil, OBJC_ASSOCIATION_RETAIN);

}

#pragma mark - Public API

- (NSUInteger)count {
    return self.backingWeakArray.count;
}

- (id)objectAtIndex:(NSUInteger)index {
    return [self _unWrap:[self.backingWeakArray objectAtIndex:index]];
}

- (void)insertObject:(id)anObject
             atIndex:(NSUInteger)index
     associatedOwner:(NSObject *)associatedOwner {
    [self.backingWeakArray insertObject:[self _wrapObject:anObject
                                         andAssociateWith:associatedOwner]
                                atIndex:index];

}

- (void)removeObjectAtIndex:(NSUInteger)index {
    __weak OKOAssociatedWeakArrayElement * element = self.backingWeakArray[index];
    [self.backingWeakArray removeObjectAtIndex:index];
    [self _disassociate:element];
}

- (NSUInteger)indexOfObject:(id)anObject {
    NSUInteger count = self.count;
    NSUInteger foundIndex = NSNotFound;
    for (NSUInteger i = 0; i < count; ++i) {
        if ([[self objectAtIndex:i] isEqual:anObject]) {
            foundIndex = i;
            break;
        }
    }
    return foundIndex;
}

- (void)removeObject:(id)anObject {
    NSUInteger foundIndex = [self indexOfObject:anObject];
    if (foundIndex != NSNotFound) {
        [self removeObjectAtIndex:foundIndex];
    }
}

- (void)addObject:(id)anObject
  associatedOwner:(NSObject *)associatedOwner {
    [self.backingWeakArray addObject:[self _wrapObject:anObject
                                      andAssociateWith:associatedOwner]];
}

- (void)removeLastObject {
    __weak OKOAssociatedWeakArrayElement * lastElement = self.backingWeakArray.lastObject;
    if (lastElement == nil) {
        return;
    }
    [self.backingWeakArray removeLastObject];
    [self _disassociate:lastElement];

    
}

- (void)replaceObjectAtIndex:(NSUInteger)index
                  withObject:(id)anObject
             associatedOwner:(NSObject *)associatedOwner {
    __weak id oldElement = self.backingWeakArray[index];
    [self.backingWeakArray replaceObjectAtIndex:index
                                     withObject:[self _wrapObject:anObject
                                                 andAssociateWith:associatedOwner]];
    [self _disassociate:oldElement];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained _Nullable [_Nonnull])buffer
                                    count:(NSUInteger)len {
    NSUInteger bufferSize =
        [self.backingWeakArray countByEnumeratingWithState:state
                                                   objects:buffer
                                                     count:len];
    for (NSUInteger i = 0; i < bufferSize; ++i) {
        buffer[i] = [self _unWrap:buffer[i]];
    }
    return bufferSize;
}

#pragma mark - Death

- (void)dealloc {
    @autoreleasepool {
        for (OKOAssociatedWeakArrayElement *element in self.backingWeakArray) {
            [self _disassociate:element];
            [element nilOwnedObject];
        }
    }
}

@end
NS_ASSUME_NONNULL_END
