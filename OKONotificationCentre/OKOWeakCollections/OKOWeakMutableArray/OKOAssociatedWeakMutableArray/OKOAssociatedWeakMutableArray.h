//
//  OKOAssociatedMutableArray.h
//  CityMapperChallange
//
//  Created by Kocsis Olivér on 2018. 04. 23..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OKOAssociatedWeakMutableArray<ObjectType> : NSObject<NSFastEnumeration>

- (ObjectType)objectAtIndex:(NSUInteger)index;

-(NSUInteger)count;

-(void)insertObject:(ObjectType)anObject
            atIndex:(NSUInteger)index
    associatedOwner:(NSObject *)associatedOwner;

-(void)removeObjectAtIndex:(NSUInteger)index ;

-(void)addObject:(ObjectType)anObject
 associatedOwner:(NSObject *)associatedOwner;

-(void)removeLastObject;

-(void)replaceObjectAtIndex:(NSUInteger)index
                 withObject:(ObjectType)anObject
            associatedOwner:(NSObject *)associatedOwner;



@end
