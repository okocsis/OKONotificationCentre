//
//  OKOAssociatedMutableArray.h
//  CityMapperChallange
//
//  Created by Oliver Kocsis on 2018. 04. 23..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface OKOAssociatedWeakMutableArray<ObjectType> : NSArray<ObjectType>

#pragma mark - Additional Public API
- (void)insertObject:(ObjectType)anObject
            atIndex:(NSUInteger)index
    associatedOwner:(NSObject *)associatedOwner;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfObject:(ObjectType)anObject;
- (void)removeObject:(ObjectType)anObject;

- (void)addObject:(ObjectType)anObject
 associatedOwner:(NSObject *)associatedOwner;

- (void)removeLastObject;

-(void)replaceObjectAtIndex:(NSUInteger)index
                 withObject:(ObjectType)anObject
            associatedOwner:(NSObject *)associatedOwner;

#pragma mark - NSMutableArray(NSExtendedMutableArray)
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;

@end

@interface OKOAssociatedWeakMutableArray<ObjectType> (unsupported)

- (instancetype)initWithObjects:(const ObjectType _Nonnull [_Nullable])objects
                          count:(NSUInteger)cnt NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

+ (instancetype)arrayWithObject:(ObjectType)anObject NS_UNAVAILABLE;
+ (instancetype)arrayWithObjects:(const ObjectType _Nonnull [_Nonnull])objects
                           count:(NSUInteger)cnt NS_UNAVAILABLE;
+ (instancetype)arrayWithObjects:(ObjectType)firstObj, ... NS_UNAVAILABLE;
+ (instancetype)arrayWithArray:(NSArray<ObjectType> *)array NS_UNAVAILABLE;
- (instancetype)initWithObjects:(ObjectType)firstObj, ... NS_UNAVAILABLE;
- (instancetype)initWithArray:(NSArray<ObjectType> *)array NS_UNAVAILABLE;
- (instancetype)initWithArray:(NSArray<ObjectType> *)array copyItems:(BOOL)flag NS_UNAVAILABLE;

@end
NS_ASSUME_NONNULL_END
