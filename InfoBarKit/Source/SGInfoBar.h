//
//  ECInfoBar.h
//  Eventus Creo
//
//  Created by Simon Gaus on 27.11.18.
//  Copyright © 2018 Simon Gaus. All rights reserved.
//

@import Cocoa;

#import "SGInfoBarTask.h"

/**
 
 ...
 
 ##Discussion
 ...
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface SGInfoBar : NSView
#pragma mark - Accessing the info bars’s value
///-------------------------------------------
/// @name Accessing the info bars’s value
///-------------------------------------------

/**
 @brief ...
 */
@property (nonatomic, strong) IBInspectable NSString *stringValue;

/**
 @brief ...
 */
@property (nonatomic, strong, nullable) IBInspectable NSString *secondaryStringValue;

/**
 @brief ...
 */
@property (nonatomic, strong) IBInspectable NSString *seperatorValue;

/**
 @brief ...
 */
@property (nonatomic, readwrite) IBInspectable NSUInteger badgeCount;



#pragma mark - Advancing the info bar
///----------------------------------
/// @name Advancing the progress bar
///----------------------------------

/**
 @brief ...
 */
@property (nonatomic, readwrite) IBInspectable CGFloat progress;



#pragma mark - Adding tasks to the info bar
///----------------------------------------
/// @name Adding tasks to the info bar
///----------------------------------------

/**
 
 @brief ...
 
 @param task ...
 
 */
- (void)addTask:(SGInfoBarTask *)task;

/**
 
 @brief ...
 
 @param tasks ...
 
 */
- (void)addTasks:(NSArray<SGInfoBarTask *> *)tasks;



#pragma mark - Removing tasks from the info bar
///--------------------------------------------
/// @name Removing tasks from the info bar
///--------------------------------------------

/**
 
 @brief ...
 
 @param task ...
 
 */
- (void)removeTask:(SGInfoBarTask *)task;

/**
 
 @brief ...
 
 @param tasks ...
 
 */
- (void)removeTasks:(NSArray<SGInfoBarTask *> *)tasks;



#pragma mark - Setting the appearance
///----------------------------------
/// @name Setting the appearance
///----------------------------------

/**
 @brief ...
 */
@property (nonatomic, strong) IBInspectable NSColor *fillColor;
/**
 @brief ...
 */
@property (nonatomic, strong) IBInspectable NSColor *outlineColor;
/**
 @brief ...
 */
@property (nonatomic, strong) IBInspectable NSColor *progressColor;
/**
 @brief ...
 */
@property (nonatomic, strong) IBInspectable NSColor *badgeColor;



@end
NS_ASSUME_NONNULL_END
