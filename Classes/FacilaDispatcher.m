//
//  FacilaDispatcher
//  Facila
//
//  Created by Grzegorz Nowicki   <grzegorz@wikia-inc.com>
//             Aleksander Balicki <alistra@wikia-inc.com>
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import "FacilaDispatcher.h"
#import "FacilaModuleProtocol.h"
#import "FacilaLayoutProtocol.h"

@interface FacilaDispatcher()

/** Registered modules */
@property (nonatomic, strong) NSArray *modules;

/** Registered actions */
@property (nonatomic, strong) NSDictionary *actions;

@end


@implementation FacilaDispatcher {

}

#pragma mark Initialization

- (instancetype)init {
    self = [super init];
    if (self) {

    }

    return self;
}

#pragma mark Public API

- (instancetype)initWithLayout:(id <FacilaLayoutProtocol>)layout {
    self = [super init];
    if (self) {
        _layout = layout;
    }

    return self;
}

- (BOOL)registerModule:(id <FacilaModuleProtocol>)module {
    if (![self isModuleRegistered:module]) {
        [self addModule:module];
        [module registerActions:self];
        return YES;
    }

    return NO;
}

- (BOOL)registerModule:(id <FacilaModuleProtocol>)module withActions:(NSArray *)actionNames {
    return NO;
}

- (BOOL)unregisterModule:(id <FacilaModuleProtocol>)module {
    if ([self isModuleRegistered:module]) {
        [self removeModule:module];
        return YES;
    }

    return NO;
}

- (BOOL)isModuleRegistered:(id <FacilaModuleProtocol>)module {
    return [self.modules containsObject:module];
}

- (BOOL)registerAction:(NSString *)actionName withBlock:(FacilaDispatcherActionBlock)actionBlock {
    if (![self isActionRegistered:actionName] && actionBlock != nil) {
        [self addAction:actionName handler:[[FacilaActionHandler alloc] initWithActionName:actionName handlerBlock:actionBlock queue:self.dispatchQueue]];
        return YES;
    }

    return NO;
}

- (BOOL)registerAction:(NSString *)actionName withBlock:(FacilaDispatcherActionBlock)actionBlock queue:(dispatch_queue_t)queue {
    if (![self isActionRegistered:actionName]) {
        [self addAction:actionName handler:[[FacilaActionHandler alloc] initWithActionName:actionName handlerBlock:actionBlock queue:queue]];
        return YES;
    }
    return NO;
}


- (BOOL)unregisterAction:(NSString *)actionName {
    if ([self isActionRegistered:actionName]) {
        [self removeAction:actionName];
        return YES;
    }

    return NO;
}

- (BOOL)isActionRegistered:(NSString *)actionName {
    return [self.actions objectForKey:actionName] != nil;
}

- (void)callAction:(NSString *)actionName withParams:(NSDictionary *)params {
    [self callAction:actionName withParams:params sync:NO];
}

- (void)callAction:(NSString *)actionName withParams:(NSDictionary *)params sync:(BOOL)sync {

    FacilaActionHandler *actionHandler = self.actions[actionName];

    actionHandler.dispatcher = self;

    if (!actionHandler || !actionHandler.canBeCalled) {
        [[[UIAlertView alloc] initWithTitle:@"Facila action not found" message:[NSString stringWithFormat:@"action: %@ params: %@", actionName, params]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }

    [actionHandler callWithParams:params sync:sync];
}


- (BOOL)canDispatchAction:(NSString *)actionName {
    // TODO: rethink purpose of that method
    return [self isActionRegistered:actionName];
}

- (dispatch_queue_t)dispatchQueue {
    if (!_dispatchQueue) {
        _dispatchQueue = dispatch_get_main_queue();
    }

    return _dispatchQueue;
}

#pragma mark --- Private methods ---


#pragma mark Modules

- (void)addModule:(id <FacilaModuleProtocol>)module {
    self.modules = [[[NSMutableArray alloc] initWithArray:self.modules] arrayByAddingObject:module];
}

- (void)removeModule:(id <FacilaModuleProtocol>)module {
    NSMutableArray *modules = [NSMutableArray arrayWithArray:self.modules];
    [modules removeObject:module];
    self.modules = [NSArray arrayWithArray:modules];
}

- (void)registerActions:(id <FacilaModuleProtocol>)module withNames:(NSArray *)names {

}

#pragma mark Actions

- (void)addAction:(NSString *)actionName handler:(FacilaActionHandler *)handler {
    NSMutableDictionary *newActions = [NSMutableDictionary dictionaryWithDictionary:self.actions];
    [newActions setObject:handler forKey:actionName];
    self.actions = [NSDictionary dictionaryWithDictionary:newActions];
}

- (void)removeAction:(NSString *)actionName {
    NSMutableDictionary *newActions = [NSMutableDictionary dictionaryWithDictionary:self.actions];
    [newActions removeObjectForKey:actionName];
    self.actions = [NSDictionary dictionaryWithDictionary:newActions];
}

@end
