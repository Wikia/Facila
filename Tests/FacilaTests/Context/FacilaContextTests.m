//
//  FacilaContextTests.m
//  Tests
//
//  Created by Gregor on 28.04.2014.
//
//

#import <XCTest/XCTest.h>
#import "Facila.h"
#import "FirstCustomContext.h"
#import "SecondCustomContext.h"

@interface FacilaContextTests : XCTestCase

@end

@implementation FacilaContextTests

- (void)setUp {
    [super setUp];

    [FacilaContext resetAllInstances];
}

- (void)tearDown {
    [super tearDown];

    [FacilaContext resetAllInstances];
}

- (void)testSingleton
{
    XCTAssertEqual([FacilaContext sharedInstance], [FacilaContext sharedInstance]);
    XCTAssertNotEqual([FacilaContext sharedInstance], [[FacilaContext alloc] init]);
}

- (void)testSettingSharedInstance {
    FacilaContext *context = [FacilaContext sharedInstance];
    FacilaContext *secondContext = [[FacilaContext alloc] init];

    XCTAssertNotEqual(context, secondContext);
    [FacilaContext setSharedInstance:secondContext];

    XCTAssertNotEqual(context, [FacilaContext sharedInstance]);
    XCTAssertEqual(secondContext, [FacilaContext sharedInstance]);
}

- (void)testResetingSingletons
{
    FacilaContext *context = [FacilaContext sharedInstance];
    [FacilaContext resetInstance];
    FacilaContext *secondContext = [FacilaContext sharedInstance];

    XCTAssertNotEqual(context, secondContext);

    FirstCustomContext *customContext = [FirstCustomContext sharedInstance];
    [FirstCustomContext resetInstance];
    FirstCustomContext *secondCustomContext = [FirstCustomContext sharedInstance];

    XCTAssertNotEqual(customContext, secondCustomContext);

    [FacilaContext resetAllInstances];
    XCTAssertNotEqual(secondContext, [FacilaContext sharedInstance]);
    XCTAssertNotEqual(secondCustomContext, [FirstCustomContext sharedInstance]);
}


- (void)testCustomSingleton
{
    FacilaDispatcher *dispatcher = [[FacilaDispatcher alloc] init];
    FacilaContext *facilaContext = [FacilaContext sharedInstance];
    facilaContext.dispatcher = dispatcher;

    FirstCustomContext *firstCustomContext = [FirstCustomContext sharedInstance];

    XCTAssertNotEqual(facilaContext, firstCustomContext);
    XCTAssertEqual(facilaContext.dispatcher, firstCustomContext.dispatcher);

    SecondCustomContext *secondCustomContext = [SecondCustomContext sharedInstance];
    XCTAssertNotEqual(facilaContext, secondCustomContext);
    XCTAssertEqual(facilaContext.dispatcher, secondCustomContext.dispatcher);
}

- (void)testOverridingSuperSingletonParams
{
    FacilaDispatcher *dispatcher = [[FacilaDispatcher alloc] init];
    FacilaContext *facilaContext = [FacilaContext sharedInstance];
    facilaContext.dispatcher = dispatcher;

    FirstCustomContext *firstCustomContext = [FirstCustomContext sharedInstance];

    XCTAssertNotEqual(facilaContext, firstCustomContext);
    XCTAssertEqual(facilaContext.dispatcher, firstCustomContext.dispatcher);

    FacilaDispatcher *differentDispatcher = [[FacilaDispatcher alloc] init];
    XCTAssertNotEqual(dispatcher, differentDispatcher);
    XCTAssertNotEqual(firstCustomContext.dispatcher, differentDispatcher);
    firstCustomContext.dispatcher = differentDispatcher;

    XCTAssertEqual(firstCustomContext.dispatcher, differentDispatcher);
    XCTAssertNotEqual(facilaContext.dispatcher, firstCustomContext.dispatcher);
}

- (void)testWeakRegister
{
    FirstCustomContext *testingContext = [[FirstCustomContext alloc] init];
    FacilaContext *facilaContext = [FacilaContext sharedInstance];

    [facilaContext.weakRegister setObject:testingContext forKey:@"testObject"];
    XCTAssertEqual(testingContext, [facilaContext.weakRegister objectForKey:@"testObject"]);

    testingContext = nil;
    XCTAssertNotEqual(testingContext, [facilaContext.weakRegister objectForKey:@"testObject"]);
}

@end
