//
//  FacilaModuleProtocol.h
//  Facila
//
//  Created by Grzegorz Nowicki   <grzegorz@wikia-inc.com>
//             Aleksander Balicki <alistra@wikia-inc.com>
//  Copyright (c) 2014 Wikia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FacilaDispatcher;

@protocol FacilaModuleProtocol <NSObject>
@required
- (void)registerActions:(FacilaDispatcher *)dispatcher;

@optional
// Returns array of supported actions
- (NSArray *)supportedActions;
- (void)handleAction:(NSString *)actionName params:(NSDictionary *)params;

@end
