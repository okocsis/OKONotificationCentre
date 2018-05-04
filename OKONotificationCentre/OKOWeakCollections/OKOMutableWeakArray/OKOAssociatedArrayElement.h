//
//  OKOWeakObject.h
//  CityMapperChallange
//
//  Created by Kocsis Olivér on 2018. 04. 19..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OKODeallocMonitor.h"
#import "OKOWeakArrayElementContainer.h"

@class OKOWeakMutableArray;

NS_ASSUME_NONNULL_BEGIN
@interface OKOAssociatedArrayElement : NSObject

@property (nonatomic, nullable, strong, readonly) id ownedObject;
@property (nonatomic, strong, readonly) OKOWeakArrayElementContainer *container;

- (nullable instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithObject:(nullable id)object
                        array:(NSMutableArray *) array
              associatedOwner:(NSObject *) associatedOwner NS_DESIGNATED_INITIALIZER;

@end
NS_ASSUME_NONNULL_END
