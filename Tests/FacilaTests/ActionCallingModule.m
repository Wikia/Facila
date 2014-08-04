//
//  ActionCallingModule
//  Tests 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 17.01.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import <Facila/FacilaDispatcher.h>
#import "ActionCallingModule.h"


@implementation ActionCallingModule {

}

- (void)registerActions:(FacilaDispatcher *)dispatcher {
    [dispatcher registerAction:@"test" withBlock:^(NSDictionary *params, FacilaDispatcher *dispatcher) {
        NSLog(@"ACM Test action block");
    }];
}

@end