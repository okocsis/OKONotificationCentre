//
//  OKODeallocMonitorObject.h
//  CityMapperChallange
//
//  Created by Oliver Kocsis on 2018. 04. 20..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol OKODeallocMonitorObjectDelegate <NSObject>

@required
- (void)didDeallocMonitoredObject;

@end

@interface OKODeallocMonitor : NSObject

@property (nonatomic, nullable, weak) id<OKODeallocMonitorObjectDelegate> delegate;

- (nullable instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMonitoredObject:(nullable NSObject *) monitoredObject NS_DESIGNATED_INITIALIZER;
+ (instancetype)monitorWithObject:(nullable NSObject *) monitoredObject;

- (void)registerMonitoredObject:(nullable NSObject *)monitoredObject;
- (void)stopMonitoring;

@end
NS_ASSUME_NONNULL_END
