//
//  CommonTestCase.m
//  OKONotificationCentreTests
//
//  Created by Oliver Kocsis on 2018. 05. 09..
//  Copyright © 2018. okocsis. All rights reserved.
//

#import "CommonTestCase.h"

@implementation AddObserverInput
- (instancetype)initWithName:(nullable NSString *)name
                      object:(nullable id)object {
    self = [super init];
    if (self) {
        _name = name;
        _object = object;
    }
    return self;
}
+ (instancetype)inputWithName:(nullable NSString *)name
                       object:(nullable id)object {
    return [[self alloc] initWithName:name
                               object:object];
}
@end

@implementation PostNotifInput
- (instancetype)initWithName:(NSString *)name
                      object:(nullable id)object
                    userInfo:(nullable NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        _name = name;
        _object = object;
        _userInfo = userInfo;
    }
    return self;
}
+ (instancetype)inputWithName:(NSString *)name
                       object:(nullable id)object
                     userInfo:(nullable NSDictionary *)userInfo {
    return [[self alloc] initWithName:name
                               object:object
                             userInfo:userInfo];
}
@end

@implementation CommonTestCase
@synthesize description = _description;

- (instancetype)initWithDesc:(NSString *)desc
            addObserverInput:(AddObserverInput *)addObesverInput
              postNotifInput:(PostNotifInput *)postNotifInput
                    inverted:(BOOL)inverted
{
    self = [super init];
    if (self) {
        _addObseverInput = addObesverInput;
        _postNotifInput = postNotifInput;
        _inverted = inverted;
        _description = desc;
    }
    return self;
}
+ (instancetype)caseWithDesc:(NSString *)desc
            addObserverInput:(AddObserverInput *)addObesverInput
              postNotifInput:(PostNotifInput *)postNotifInput
                    inverted:(BOOL)inverted {
    return [[self alloc] initWithDesc:desc
                     addObserverInput:addObesverInput
                       postNotifInput:postNotifInput
                             inverted:inverted];
}

@end
