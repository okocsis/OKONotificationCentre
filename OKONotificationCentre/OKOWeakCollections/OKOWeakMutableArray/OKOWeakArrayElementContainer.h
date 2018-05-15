//
//  OKOWeakObjectContainer.h
//  CityMapperChallange
//
//  Created by Oliver Kocsis on 2018. 04. 19..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OKODeallocMonitor.h"

NS_ASSUME_NONNULL_BEGIN
@interface OKOWeakArrayElementContainer : NSObject

@property (nonatomic, nullable, weak, readonly) id weakElement;
@property (nonatomic, weak, readonly) NSMutableArray<OKOWeakArrayElementContainer *> *array;
@property (nonatomic, strong, readonly) OKODeallocMonitor *deallocMonitor;

- (nullable instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithWeakElement:(id) weakElement
                              array:(NSMutableArray<OKOWeakArrayElementContainer *> *)array NS_DESIGNATED_INITIALIZER;
- (void)removeYourself;

@end
NS_ASSUME_NONNULL_END
