//
//  OKOMutableWeakArray.h
//
//  Created by Kocsis Olivér on 2015. 07. 07..
//  Copyright (c) 2018. Kocsis Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface OKOWeakMutableArray<ObjectType> : NSMutableArray<ObjectType>

-(void) compact;
-(void) removeNilObjects; // same as compact

#pragma mark - NSArray overrides
- (instancetype)init;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability"
-(nullable ObjectType)objectAtIndex:(NSUInteger)index;
#pragma clang diagnostic pop

-(NSUInteger)count;

#pragma mark - NSMutableArray overrides
-(void)insertObject:(nullable ObjectType)anObject atIndex:(NSUInteger)index;

-(void)removeObjectAtIndex:(NSUInteger)index ;

-(void)addObject:(nullable ObjectType)anObject ;

-(void)removeLastObject;

-(void)replaceObjectAtIndex:(NSUInteger)index withObject:(nullable ObjectType)anObject ;

@end
NS_ASSUME_NONNULL_END
