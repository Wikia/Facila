//
//  FacilaDispatcher
//  Facila
//
//  Created by Grzegorz Nowicki   <grzegorz@wikia-inc.com>
//             Aleksander Balicki <alistra@wikia-inc.com>
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacilaActionHandler.h"

@protocol FacilaModuleProtocol;
@class FacilaDispatcher;
@protocol FacilaLayoutProtocol;

/**
 `FacilaDispatcher` handle communication between modules.
*/
@interface FacilaDispatcher : NSObject

/** Registered modules */
@property (nonatomic, readonly, strong) NSArray *modules;

/** Registered actions */
@property (nonatomic, readonly, strong) NSDictionary *actions;

/** Default queue to call blocks by dispatcher */
@property (nonatomic, assign) dispatch_queue_t dispatchQueue;

/** Layout controller class */
@property (nonatomic, strong) id <FacilaLayoutProtocol> layout;

/**
 Initialize Facila with layout handler
 @param layout Layout object (ex. UINavigationController)
*/
- (instancetype)initWithLayout:(id <FacilaLayoutProtocol>)layout;

/**
 Register module

 @param module Module object with FacilaModuleProtocol interface
 @returns NO if module is already registered otherwise returns YES
*/
- (BOOL)registerModule:(id <FacilaModuleProtocol>)module;

/**
 Register module with particular actions from it
 Instead of action names nil can be passed to register module without any action

 @param module Module object with FacilaModuleProtocol interface
 @param actionNames Array with action names to register from module
 @returns NO if module is already registered otherwise returns YES
*/
- (BOOL)registerModule:(id <FacilaModuleProtocol>)module withActions:(NSArray *)actionNames;

/**
 Unregister module

 @param module Module to unregister
 @returns YES if module was successfully unregistered
*/
- (BOOL)unregisterModule:(id <FacilaModuleProtocol>)module;

/**
 Check if module is registered

 @param module Module with FacilaModuleProtocol interface
 @returns YES if module is already registered
*/
- (BOOL)isModuleRegistered:(id <FacilaModuleProtocol>)module;

/**
 Register an action that can be called
 @see [dispatchQueue] Action Block will be called in `dispatchQueue`

 @param actionName Name of action
 @param actionBlock Block handler for action
 @returns NO if action is already registered or if block is empty
*/
- (BOOL)registerAction:(NSString *)actionName withBlock:(FacilaDispatcherActionBlock)actionBlock;

/**
 Register an action that can be called

 @param actionName Name of action
 @param actionBlock Block handler for action
 @param queue Queue to call action block
 @returns NO if action is already registered
*/
- (BOOL)registerAction:(NSString *)actionName withBlock:(FacilaDispatcherActionBlock)actionBlock queue:(dispatch_queue_t)queue;

/**
 Unregister action

 @param actionName Name of action
 @returns YES if action has been successfully unregistered
*/
- (BOOL)unregisterAction:(NSString *)actionName;

/**
 Check if action is registered

 @param actionName Name of action
 @returns YES if action is already register
*/
- (BOOL)isActionRegistered:(NSString *)actionName;

/**
 Call action with params

 @param actionName Name of action to call
 @param params Dictionary with named params
*/
- (void)callAction:(NSString *)actionName withParams:(NSDictionary *)params;

/**
Call action with params possibly synchronously

@param actionName Name of action to call
@param params Dictionary with named params
@param sync Should dispatch_sync be used instead of dispatch_async
*/
- (void)callAction:(NSString *)actionName withParams:(NSDictionary *)params sync:(BOOL)sync;

/**
 Check if action can be performed

 @returns YES if action is registered
*/
- (BOOL)canDispatchAction:(NSString *)actionName;

@end
