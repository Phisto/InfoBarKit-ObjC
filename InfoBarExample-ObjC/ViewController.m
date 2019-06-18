//
//  ViewController.m
//  InfoBarExample-ObjC
//
//  Created by Simon Gaus on 30.03.19.
//  Copyright © 2019 Simon Gaus. All rights reserved.
//

#import "ViewController.h"

#import <InfoBarKit/InfoBarKit.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}



- (IBAction)test:(id)sender {
    
    SGInfoBarTask *newTask = [[SGInfoBarTask alloc] init];
    newTask.taskName = @"NAME";
    newTask.taskProgressDescription = @"DESCRIPTION";
    newTask.determined = YES;
    newTask.doubleValue = 0.4f;
    
    [self.infoBar addTask:newTask];
}


@end
