//
//  OKOMutableWeakArray.h
//
//  Created by Kocsis Olivér on 2015. 07. 07..
//  Copyright (c) 2018. Kocsis Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface OKOWeakMutableArray<ObjectType> : NSMutableArray<ObjectType>

// WARNING: the class only supports encoding from NSCoding,
// decoding to an Array that doesn't hold onto it's elements doesn't make sense
// you can decode a previously encoded OKOWeakMutableArray to an NSMutableArray instead
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

@interface NSArray(OKOWeakMutableArrayFactory)

@property (nonatomic, copy, readonly) OKOWeakMutableArray *oko_weakMutableCopy;

@end
NS_ASSUME_NONNULL_END
