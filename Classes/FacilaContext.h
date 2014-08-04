//
//  FacilaContext
//  Facila 
//
//  Created by Grzegorz Nowicki <grzegorz@wikia-inc.com> on 15.04.2014.
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FacilaDispatcher;
@protocol FacilaLayoutProtocol;

@interface FacilaContext : NSObject

@property (nonatomic, strong) FacilaDispatcher *dispatcher;
@property (nonatomic, strong) UIViewController <FacilaLayoutProtocol> *layout;

@property (nonatomic, strong) NSMutableDictionary *strongRegister;
@property (nonatomic, strong) NSMapTable *weakRegister;

+ (instancetype)sharedInstance;

+ (void)setSharedInstance:(FacilaContext *)sharedInstance;
+ (void)resetAllInstances;
+ (void)resetInstance;

@end
