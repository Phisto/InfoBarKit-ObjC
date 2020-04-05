//
//  ViewController.m
//  InfoBarExample-ObjC
//
//  Created by Simon Gaus on 30.03.19.
//  Copyright © 2019 Simon Gaus. All rights reserved.
//

#import "ViewController.h"

@import InfoBarKit;

@implementation ViewController
#pragma mark - View Controller Methdoes

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Test methodes

- (IBAction)setPrimaryString:(id)sender {
    
    self.infoBar.stringValue = self.stringValueTextField.stringValue;
}

- (IBAction)setSeperatorString:(id)sender {
    
    self.infoBar.seperatorValue = self.seperatorValueTextField.stringValue;
}

- (IBAction)setSecondaryString:(id)sender {
    
    self.infoBar.secondaryStringValue = self.secondaryStringValueTextField.stringValue;
}

- (IBAction)changeBadgeCount:(id)sender {
    
    NSStepper *badgeStepper = (NSStepper *)sender;
    self.infoBar.badgeCount = (NSInteger)badgeStepper.floatValue;
}


- (IBAction)changeProgress:(id)sender {
    
    NSStepper *progressStepper = (NSStepper *)sender;
    self.infoBar.progress = progressStepper.floatValue;
}

- (IBAction)test:(id)sender {

    SGInfoBarTask *newTask = [[SGInfoBarTask alloc] init];
    newTask.taskName = @"Transcoding";
    newTask.taskProgressDescription = @"1 von 2";
    newTask.determined = YES;
    newTask.doubleValue = 0.4f;
    
    [self.infoBar addTask:newTask];
}

#pragma mark -
@end
