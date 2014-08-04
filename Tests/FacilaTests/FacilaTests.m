//
//  FacilaTests.m
//  FacilaTests
//
//  Created by Gregor on 16.01.2014.
//
//

#import <XCTest/XCTest.h>
#import "FacilaModule.h"

@interface FacilaTests : XCTestCase

@end

@implementation FacilaTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFacilaModueSampleTest
{
    FacilaModule *module = [[FacilaModule alloc] init];
    XCTAssertTrue([module isKindOfClass:[FacilaModule class]], @"Testing FacilaModule Class");
}


@end
