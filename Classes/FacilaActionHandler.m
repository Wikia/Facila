//
//  FacilaActionHandler
//  Facila 
//
//  Created by Grzegorz Nowicki   <grzegorz@wikia-inc.com>
//             Aleksander Balicki <alistra@wikia-inc.com>
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import "FacilaActionHandler.h"


@interface FacilaActionHandler ()

@property (nonatomic, readwrite, strong) NSString *actionName;

@property (nonatomic, readwrite, strong) FacilaDispatcherActionBlock block;
@property (nonatomic, readwrite, assign) dispatch_queue_t queue;


@end

@implementation FacilaActionHandler {

}

- (instancetype)initWithActionName:(NSString *)actionName handlerBlock:(FacilaDispatcherActionBlock)handlerBlock queue:(dispatch_queue_t)queue {
    self = [super init];
    if (self) {
        self.actionName = actionName;
        self.block = handlerBlock;
        self.queue = queue;
    }

    if (!self.block || !self.actionName) {
        return nil;
    }

    return self;
}

- (BOOL)canBeCalled {

    if (!self.dispatcher) {
        return NO;
    }

    return (self.block != nil);
}

- (void)callWithParams:(NSDictionary *)params {
    [self callWithParams:params sync:NO];
}

- (void)callWithParams:(NSDictionary *)params sync:(BOOL)sync {

    if (!self.canBeCalled) {
        [NSException raise:@"FacilaInternalInconsistencyException" format:@"Calling a handler to action %@ that can't be called", self.actionName];
    }


    if (sync) {
        [self callSync:params];
    } else {
        [self callAsync:params];
    }
}

- (void)callSync:(NSDictionary *)params {
    self.block(params, self.dispatcher);
}

- (void)callAsync:(NSDictionary *)params {
    dispatch_async(self.queue ?: dispatch_get_main_queue(), ^{
        self.block(params, self.dispatcher);
    });
}

@end
