//
//  SGInfoBarTask.h
//  SGInfoBar
//
//  Created by Simon Gaus on 24.12.18.
//  Copyright © 2018 Simon Gaus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SGInfoBarTask : NSObject

@property (nonatomic, strong) NSString *taskName;

@property (nonatomic, strong) NSString *taskProgressDescription;

@property (nonatomic, readwrite) CGFloat doubleValue;

@property (nonatomic, readwrite, getter=isDetermined) BOOL determined;

@property (nonatomic, readwrite) BOOL done;

+ (instancetype)taskWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
