//
//  ViewController.h
//  InfoBarExample-ObjC
//
//  Created by Simon Gaus on 30.03.19.
//  Copyright © 2019 Simon Gaus. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SGInfoBar;

@interface ViewController : NSViewController

@property (nonatomic, weak) IBOutlet SGInfoBar *infoBar;

@property (nonatomic, weak) IBOutlet NSTextField *stringValueTextField;
@property (nonatomic, weak) IBOutlet NSTextField *seperatorValueTextField;
@property (nonatomic, weak) IBOutlet NSTextField *secondaryStringValueTextField;

@end

