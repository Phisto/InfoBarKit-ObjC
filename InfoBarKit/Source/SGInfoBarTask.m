//
//  SGInfoBarTask.m
//  SGInfoBar
//
//  Created by Simon Gaus on 24.12.18.
//  Copyright © 2018 Simon Gaus. All rights reserved.
//

#import "SGInfoBarTask.h"

@implementation SGInfoBarTask
#pragma mark - Creating a info bar task object


+ (instancetype)taskWithName:(NSString *)name {
    
    return [[[self class] alloc] initWithName:name];
}


- (instancetype)initWithName:(NSString *)name {
    
    self = [super init];
    if (self) {
     
        _done = NO;
        _taskName = name;
        _determined = NO;
    }
    return self;
}


#pragma mark -
@end
