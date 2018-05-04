//
//  OKOAssociatedMutableArray.m
//  CityMapperChallange
//
//  Created by Kocsis Olivér on 2018. 04. 23..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import "OKOAssociatedMutableArray.h"

@interface OKOWeakMutableArray (protected)
@property (nonatomic, strong, readonly) NSMutableArray<OKOWeakArrayElementContainer *> *backingArray;
@end

@implementation OKOAssociatedMutableArray

- (OKOAssociatedArrayElement *) wrapObject:(id)anObject
                          andAssociateWith:(NSObject *)associatedOwner {
    return [[OKOAssociatedArrayElement alloc] initWithObject:anObject
                                                       array:self.backingArray
                                             associatedOwner:associatedOwner];
}

#pragma mark - NSArray overrides

- (NSUInteger)count {
    return self.backingArray.count;
}

- (id)objectAtIndex:(NSUInteger)index {
    id object = [super objectAtIndex:index];
    if ([object isKindOfClass:[OKOAssociatedArrayElement class]]) {
        OKOAssociatedArrayElement *element = object;
        return element.ownedObject;
    }
    return object;
}

#pragma mark - Public API

- (void)insertObject:(id)anObject
             atIndex:(NSUInteger)index
     associatedOwner:(NSObject *)associatedOwner {
    OKOAssociatedArrayElement * element =
    [self wrapObject:anObject
    andAssociateWith:associatedOwner];
    [self.backingArray insertObject:element.container atIndex:index];
}

- (void)addObject:(id)anObject
  associatedOwner:(NSObject *)associatedOwner {
    OKOAssociatedArrayElement * element =
    [self wrapObject:anObject
    andAssociateWith:associatedOwner];
    [self.backingArray addObject:element.container];
}

- (void)replaceObjectAtIndex:(NSUInteger)index
                  withObject:(id)anObject
             associatedOwner:(NSObject *)associatedOwner {
    OKOAssociatedArrayElement * element =
    [self wrapObject:anObject
    andAssociateWith:associatedOwner];
    [self.backingArray addObject:element.container];
}
@end
