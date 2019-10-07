//
//  SGInfoBarTask.h
//  SGInfoBar
//
//  Created by Simon Gaus on 24.12.18.
//  Copyright © 2018 Simon Gaus. All rights reserved.
//

@import Foundation;

/**
 
 An object representing a terminable process or task.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface SGInfoBarTask : NSObject
#pragma mark - Describing a task
///----------------------------------------------
/// @name Describing a task
///----------------------------------------------

/**
 @brief The name of the task.
 @discussion <info bar text value> <info bar seperator value> <task name> ( | <task progress description>)
 */
@property (nonatomic, strong) NSString *taskName;
/**
 @brief A textual description of the task progress for example if the task is part of a multi-task process ( e.g. "Part 2 of 5").
 @discussion <info bar text value> <info bar seperator value> <task name> ( | <task progress description>)
 */
@property (nonatomic, strong, nullable) NSString *taskProgressDescription;
/**
 @brief The value that indicates the current progress of the task.
 @discussion By default, a task progress goes from 0.0 to 100.0. For an indeterminate task this value gets ignored.
 */
@property (nonatomic, readwrite) CGFloat doubleValue;
/**
@brief A Boolean that indicates whether the task is determinate.
*/
@property (nonatomic, readwrite, getter=isDetermined) BOOL determined;



#pragma mark - Creating a task
///-------------------------------------------
/// @name Creating a task
///-------------------------------------------

/**
 
 @brief Creates a task with the given name.
 
 @return A SGInfoBarTask object with the given name.
 
 */
+ (instancetype)taskWithName:(NSString *)name;



@end

NS_ASSUME_NONNULL_END
