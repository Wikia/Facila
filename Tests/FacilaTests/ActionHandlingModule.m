//
//  ActionHandlingModule
//  Tests 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 17.01.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import <Facila/FacilaDispatcher.h>
#import "ActionHandlingModule.h"


@implementation ActionHandlingModule {

}

- (id)init {
    self = [super init];
    if (self) {
        self.methodCallsCount = 0;
    }

    return self;
}

- (void)handleActionParams:(NSDictionary *)params {
    self.methodCallsCount++;
    self.params = params;
}

- (void)registerActions:(FacilaDispatcher *)dispatcher {

    // Register sample action
    [dispatcher registerAction:AHMSampleActionName withBlock:^(NSDictionary *params, FacilaDispatcher *facilaDispatcher) {
        [self handleActionParams:params];
    }];

}

@end