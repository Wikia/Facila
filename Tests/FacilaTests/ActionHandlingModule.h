//
//  ActionHandlingModule
//  Tests 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 17.01.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Facila/FacilaModuleProtocol.h>

static NSString *AHMSampleActionName = @"SampleActionName";

@interface ActionHandlingModule : NSObject<FacilaModuleProtocol>

@property (nonatomic, assign) NSInteger methodCallsCount;
@property (nonatomic, strong) NSString *actionName;
@property (nonatomic, strong) NSDictionary *params;

- (void)handleActionParams:(NSDictionary *)params;

@end