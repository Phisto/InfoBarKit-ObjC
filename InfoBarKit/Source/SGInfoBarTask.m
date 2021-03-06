//
//  SGInfoBarTask.m
//  SGInfoBar
//
//  Created by Simon Gaus on 24.12.18.
//  Copyright © 2018 Simon Gaus. All rights reserved.
//

#import "SGInfoBarTask.h"

#pragma mark - CATEGORIES


@interface SGInfoBarTask (/* Private */)
/// A unique string identifying the task.
@property (nonatomic, strong) NSString *uniqueID;

@end


#pragma mark - IMPLEMENTATION


@implementation SGInfoBarTask
#pragma mark - Creating a task

+ (instancetype)taskWithName:(NSString *)name {
    
    return [[[self class] alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString *)name {
    
    self = [super init];
    if (self) {
     
        _taskName = name;
        _determined = NO;
        _uniqueID = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (instancetype)init {
    
    return [self initWithName:@""];
}

#pragma mark - Comparing task objects

- (BOOL)isEqual:(id)object {
    
    if (object == self) {
        return YES;
    }
    
    if (![object isKindOfClass:[SGInfoBarTask class]]) {
        return NO;
    }
    
    if ([[(SGInfoBarTask *)object uniqueID] isEqualToString:self.uniqueID]) {
        return YES;
    }
    
    return NO;
}

#pragma mark -
@end
