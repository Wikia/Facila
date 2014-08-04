//
//  FacilaContext
//  Facila 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 15.04.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import "FacilaContext.h"
#import "FacilaDispatcher.h"
#import "FacilaLayoutProtocol.h"

static NSMutableDictionary* _singletons;

@implementation FacilaContext {
    FacilaDispatcher *_dispatcher;
    id <FacilaLayoutProtocol> _layout;
}

#pragma mark Singleton methods
+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singletons = [NSMutableDictionary dictionary];
    });

    id instance = nil;
    @synchronized(self) {
        NSString* klass = NSStringFromClass(self);
        instance = _singletons[klass];
        if (!instance) {
            instance = [self new];
            _singletons[klass] = instance;
        }
    }
    return instance;
}

+ (instancetype)sharedInstance {
    return [self singleton];
}

+ (void)setSharedInstance:(FacilaContext *)sharedInstance {
    NSString *klass = NSStringFromClass([sharedInstance class]);
    _singletons[klass] = sharedInstance;
}

+ (void)resetAllInstances {
    @synchronized (self) {
        [_singletons removeAllObjects];
    }
}

+ (void)resetInstance {
    @synchronized (self) {
        NSString* klass = NSStringFromClass(self);
        if (_singletons[klass]) {
            [_singletons removeObjectForKey:klass];
        }
    }
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];

    if (self) {
        self.strongRegister = [NSMutableDictionary new];
        self.weakRegister = [NSMapTable strongToWeakObjectsMapTable];
    }

    return self;
}

#pragma mark -

- (FacilaDispatcher *)dispatcher {
    if (_dispatcher == nil && ![[self class] isEqual:[FacilaContext class]]) {
        return [FacilaContext sharedInstance].dispatcher;
    }

    return _dispatcher;
}

- (void)setDispatcher:(FacilaDispatcher *)dispatcher {
    _dispatcher = dispatcher;
}

- (id <FacilaLayoutProtocol>)layout {
    if (_layout == nil && ![[self class] isEqual:[FacilaContext class]]) {
        return [FacilaContext sharedInstance].layout;
    }

    return _layout;
}

- (void)setLayout:(id <FacilaLayoutProtocol>)layout {
    _layout = layout;
}

@end
