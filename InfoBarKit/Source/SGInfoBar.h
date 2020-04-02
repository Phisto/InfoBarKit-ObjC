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
 
 An interface that provides visual feedback to the user about the status of ongoing tasks.
 
 ##Discussion
 The info bar can visualize determinate or indeterminate task. A determinate task will displays as a completion percentage of a task. An indeterminate task will be displayed as busy without providing a visual indication of how long the task will take.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface SGInfoBar : NSView
#pragma mark - Info bars display values
///---------------------------------------------------------
/// @name Info bars display values
///---------------------------------------------------------

/**
 @brief The string that is displayed by the info bar.
 @discussion <info bar text value> <info bar seperator value> <info bar secondary value>
 */
@property (nonatomic, strong) IBInspectable NSString *stringValue;
/**
 @brief The secondary string that is displayed by the info bar.
 @discussion <info bar text value> <info bar seperator value> <info bar secondary value>
 */
@property (nonatomic, strong) IBInspectable NSString *seperatorValue;
/**
 @brief The secondary string that is displayed by the info bar.
 @discussion <info bar text value> <info bar seperator value> <info bar secondary value>
 */
@property (nonatomic, strong, nullable) IBInspectable NSString *secondaryStringValue;
/**
 @brief The the number of task that are displayed by the info bar.
 */
@property (nonatomic, readwrite) IBInspectable NSUInteger badgeCount;



#pragma mark - Advancing the info bar
///------------------------------------------------------
/// @name Advancing the progress bar
///------------------------------------------------------

/**
 @brief The value that indicates the current extent of the progress indicator.
 */
@property (nonatomic, readwrite) IBInspectable CGFloat progress;


#pragma mark - Adding tasks
///--------------------------------------
/// @name Adding tasks
///--------------------------------------

/**
 @brief Adds the given task to the info bar.
 @param task The task to add.
 */
- (void)addTask:(SGInfoBarTask *)task;

/**
 @brief Adds the given tasks to the info bar.
 @param tasks The tasks to add.
 */
- (void)addTasks:(NSArray<SGInfoBarTask *> *)tasks;


#pragma mark - Removing tasks
///-----------------------------------------
/// @name Removing tasks
///-----------------------------------------

/**
 @brief Removes the given task from the info bar.
 @param task The task to remove.
 */
- (void)removeTask:(SGInfoBarTask *)task;

/**
 @brief Removes the given tasks from the info bar.
 @param tasks The tasks to remove.
 */
- (void)removeTasks:(NSArray<SGInfoBarTask *> *)tasks;


#pragma mark - Appearance
///-----------------------------------
/// @name Appearance
///-----------------------------------

/**
 @brief The color used to fill the info bar.
 */
@property (nonatomic, strong) IBInspectable NSColor *fillColor;
/**
 @brief The color used to draw the info bars outline.
 */
@property (nonatomic, strong) IBInspectable NSColor *outlineColor;
/**
 @brief The color used to draw the info bars progress.
 */
@property (nonatomic, strong) IBInspectable NSColor *progressColor;
/**
 @brief The color used to draw the info bars badge count.
 */
@property (nonatomic, strong) IBInspectable NSColor *badgeColor;


@end

NS_ASSUME_NONNULL_END
