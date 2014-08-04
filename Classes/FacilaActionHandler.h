//
//  FacilaActionHandler
//  Facila 
//
//  Created by Grzegorz Nowicki   <grzegorz@wikia-inc.com>
//             Aleksander Balicki <alistra@wikia-inc.com>
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FacilaDispatcher;

/**
 `FacilaDispatcherActionBlock` Block to handle action

 @param params Dictionary with action params
 @param dispatcher Current dispatcher
*/
typedef void (^FacilaDispatcherActionBlock)(NSDictionary *params, FacilaDispatcher *dispatcher);

/**
 `FacilaDispatcherCompletionBlock` Block that will be called after calling action

 @param dispatcher Current dispatcher
*/
typedef void (^FacilaDispatcherCompletionBlock)(FacilaDispatcher *dispatcher);


@interface FacilaActionHandler : NSObject

@property (nonatomic, readonly, strong) NSString *actionName;

/** Calling properties */
@property (nonatomic, readonly, strong) FacilaDispatcherActionBlock block;
@property (nonatomic, readonly, assign) dispatch_queue_t queue;

@property (nonatomic, strong) FacilaDispatcher *dispatcher;

- (instancetype)initWithActionName:(NSString *)actionName
                      handlerBlock:(FacilaDispatcherActionBlock) handlerBlock
                             queue:(dispatch_queue_t)queue;

- (BOOL)canBeCalled;

- (void)callWithParams:(NSDictionary *)params;
- (void)callWithParams:(NSDictionary *)params sync:(BOOL)sync;

@end
