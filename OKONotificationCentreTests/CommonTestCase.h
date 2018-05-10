//
//  CommonTestCase.h
//  OKONotificationCentreTests
//
//  Created by Kocsis Olivér on 2018. 05. 09..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface AddObserverInput : NSObject
@property (nonatomic, nullable, strong, readonly) NSString *name;
@property (nonatomic, nullable, strong, readonly) id object;
- (instancetype)initWithName:(nullable NSString *)name
                      object:(nullable id)object;
+ (instancetype)inputWithName:(nullable NSString *)name
                       object:(nullable id)object;

@end


@interface PostNotifInput : NSObject
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, nullable, strong, readonly) id object;
@property (nonatomic, nullable, strong, readonly) NSDictionary *userInfo;
- (instancetype)initWithName:(NSString *)name
                      object:(nullable id)object
                    userInfo:(nullable NSDictionary *)userInfo;
+ (instancetype)inputWithName:(NSString *)name
                       object:(nullable id)object
                     userInfo:(nullable NSDictionary *)userInfo;

@end


@interface CommonTestCase : NSObject

@property (nonatomic, strong, readonly) NSString *description;
@property (nonatomic, strong, readonly) AddObserverInput *addObseverInput;
@property (nonatomic, strong, readonly) PostNotifInput *postNotifInput;
@property (nonatomic) BOOL inverted;

- (instancetype)initWithDesc:(NSString *)desc
            addObserverInput:(AddObserverInput *)addObesverInput
              postNotifInput:(PostNotifInput *)postNotifInput
                    inverted:(BOOL)inverted;
+ (instancetype)caseWithDesc:(NSString *)desc
            addObserverInput:(AddObserverInput *)addObesverInput
              postNotifInput:(PostNotifInput *)postNotifInput
                    inverted:(BOOL)inverted;

@end
NS_ASSUME_NONNULL_END
