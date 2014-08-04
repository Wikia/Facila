//
//  FacilaLayoutProtocol
//  Facila 
//
//  Created by Grzegorz Nowicki   <grzegorz@wikia-inc.com>
//             Aleksander Balicki <alistra@wikia-inc.com>
//  Copyright (c) 2014 Wikia Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FacilaLayoutProtocol <NSObject>

@optional
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated; // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.
- (UIViewController *)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated; // Pops view controllers until the one specified is on top. Returns the popped controllers.
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated; // Pops until there's only a single view controller left on the stack. Returns the popped controllers.

/*
  Defines the transition style that will be used for this view controller when it is presented modally. Set
  this property on the view controller to be presented, not the presenter.  Defaults to
  UIModalTransitionStyleCoverVertical.
*/
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion NS_AVAILABLE_IOS(5_0);
// The completion handler, if provided, will be invoked after the dismissed controller's viewDidDisappear: callback is invoked.
- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion;
- (UIViewController *)topViewController;

- (NSArray *)viewControllers; // The current view controller stack.

@end
