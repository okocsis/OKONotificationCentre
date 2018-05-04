//
//  OKOAssociatedMutableArray.h
//  CityMapperChallange
//
//  Created by Kocsis Olivér on 2018. 04. 23..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import "OKOWeakMutableArray.h"
#import "OKOAssociatedArrayElement.h"

@interface OKOAssociatedMutableArray<ObjectType> : OKOWeakMutableArray<ObjectType>

- (ObjectType)objectAtIndex:(NSUInteger)index;

-(void)insertObject:(ObjectType)anObject
            atIndex:(NSUInteger)index
    associatedOwner:(NSObject *)associatedOwner;

-(void)addObject:(ObjectType)anObject
 associatedOwner:(NSObject *)associatedOwner;

-(void)replaceObjectAtIndex:(NSUInteger)index
                 withObject:(ObjectType)anObject
            associatedOwner:(NSObject *)associatedOwner;
@end
