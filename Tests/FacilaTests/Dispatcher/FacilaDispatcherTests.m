//
//  FacilaDispatcherTests.m
//  Tests
//
//  Created by Gregor on 16.01.2014.
//
//

#import <XCTest/XCTest.h>
#import "FacilaDispatcher.h"
#import "ActionHandlingModule.h"
#import "ActionCallingModule.h"
#import "XCTestCase+AsyncTesting.h"

@interface FacilaDispatcherTests : XCTestCase

@property (nonatomic, strong) FacilaDispatcher *dispatcher;
@property (nonatomic, strong) ActionHandlingModule *actionHandlingModule;
@property (nonatomic, strong) ActionCallingModule *actionCallingModule;

@end

@implementation FacilaDispatcherTests

- (void)setUp
{
    [super setUp];

    _dispatcher = [[FacilaDispatcher alloc] init];
    _actionHandlingModule = [[ActionHandlingModule alloc] init];
    _actionCallingModule = [[ActionCallingModule alloc] init];
}

- (void)tearDown
{
    [super tearDown];

    _dispatcher = nil;
    _actionHandlingModule = nil;
    _actionCallingModule = nil;
}

- (void)testFacilaDispatcherInstance
{
    XCTAssertTrue([self.dispatcher isKindOfClass:[FacilaDispatcher class]], @"FacilaDispatcher instance problem.");
}

- (void)testFacilaDispatcher_RegisterAndUnregisterModule
{
    [self registerActionHandlingModule];
    XCTAssertEqual([self.dispatcher.modules count], (NSUInteger)1, @"Modules count is wrong after module registration.");
    XCTAssertEqual([self.dispatcher.modules firstObject], self.actionHandlingModule, @"Problem with adding module.");

    [self registerActionCallingModule];
    XCTAssertEqual([self.dispatcher.modules count], (NSUInteger)2);
    XCTAssertEqual([self.dispatcher.modules lastObject], self.actionCallingModule);

    BOOL moduleUnregistrationSuccess = [self.dispatcher unregisterModule:self.actionHandlingModule];
    BOOL secondModuleUnregisterSuccess = [self.dispatcher unregisterModule:self.actionCallingModule];
    XCTAssertTrue(moduleUnregistrationSuccess);
    XCTAssertTrue(secondModuleUnregisterSuccess);
    XCTAssertEqual([self.dispatcher.modules count], (NSUInteger)0, @"Modules count is wrong after module unregistration.");
    XCTAssertFalse([self.dispatcher isModuleRegistered:self.actionHandlingModule]);
    XCTAssertFalse([self.dispatcher isModuleRegistered:self.actionCallingModule]);
}

- (void)testFacilaDispatcher_ActionRegistrationAndUnregistration
{

    NSString *rawActionName = @"rawAction";
    NSDictionary *testParams = @{
        @"first": @1,
        @"second": @2
    };

    BOOL actionRegistration = [self.dispatcher registerAction:rawActionName withBlock:^(NSDictionary *params, FacilaDispatcher *dispatcher) {
        XCTAssertEqual(self.dispatcher, dispatcher);
        XCTAssertEqual(testParams, params);
    }];

    XCTAssertTrue(actionRegistration);
    [self.dispatcher callAction:rawActionName withParams:testParams completion:^(FacilaDispatcher *dispatcher) {
        XCTAssertEqual(self.dispatcher, dispatcher);
    }];

    [self waitForTimeout:1];
}


- (void)testFacilaDispatcher_ActionCalling
{
    [self registerActionHandlingModule];

    NSDictionary *testingParams = @{
            @"param1": @1,
            @"param2": @2
    };

    [self.dispatcher callAction:AHMSampleActionName withParams:testingParams];
    [self waitForTimeout:1];

    XCTAssertEqual(self.actionHandlingModule.methodCallsCount, 1);
    XCTAssertEqual(self.actionHandlingModule.params, testingParams);

    FacilaDispatcherCompletionBlock completionBlock = ^(FacilaDispatcher *dispatcher) {
        XCTAssertEqual(self.dispatcher, dispatcher);
    };

    [self.dispatcher callAction:AHMSampleActionName withParams:testingParams completion:completionBlock];
    [self.dispatcher callAction:AHMSampleActionName withParams:testingParams completion:completionBlock queue:dispatch_get_main_queue()];
    [self waitForTimeout:1];
    XCTAssertEqual(self.actionHandlingModule.methodCallsCount, 3);
}

#pragma mark ------ Helper Methods -------

- (void)registerActionHandlingModule
{
    BOOL moduleRegistrationSuccess = [self.dispatcher registerModule:self.actionHandlingModule];
    XCTAssertTrue(moduleRegistrationSuccess);
    XCTAssertTrue([self.dispatcher isModuleRegistered:self.actionHandlingModule], @"Is module register dosent work!");
    XCTAssertTrue([self.dispatcher isActionRegistered:AHMSampleActionName]);
    XCTAssertTrue([self.dispatcher canDispatchAction:AHMSampleActionName]);

}

- (void)registerActionCallingModule
{
    BOOL moduleRegistrationSuccess = [self.dispatcher registerModule:self.actionCallingModule];
    XCTAssertTrue(moduleRegistrationSuccess);
    XCTAssertTrue([self.dispatcher isModuleRegistered:self.actionCallingModule]);
}

@end
