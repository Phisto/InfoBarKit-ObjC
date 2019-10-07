//
//  ECInfoBar.m
//  Eventus Creo
//
//  Created by Simon Gaus on 27.11.18.
//  Copyright © 2018 Simon Gaus. All rights reserved.
//

#import "SGInfoBar.h"

#pragma mark - CONSTANTS
///----------------------------------
/// @name CONSTANTS
///----------------------------------



static CGFloat const kSGTextFieldMinMarign = 8.0f;
static CGFloat const kSGTextFieldMaxMarign = 25.0f;



#pragma mark - CATEGORIES
///-----------------------------------
/// @name CATEGORIES
///-----------------------------------



@interface SGInfoBar (/* Private */)

@property (nonatomic, strong) NSProgressIndicator *undeterminedProgressIndicator;
@property (weak, nonatomic) NSLayoutConstraint *labelConstraint;
@property (nonatomic, strong) NSTextField *infoTextField;
@property (nonatomic, strong) NSMutableArray<SGInfoBarTask *> *tasks;

@end



#pragma mark - IMPLEMENTATION
///-----------------------------------------
/// @name IMPLEMENTATION
///-----------------------------------------



@implementation SGInfoBar
#pragma mark - Synthesize


@synthesize fillColor = _fillColor;
@synthesize outlineColor = _outlineColor;
@synthesize progressColor = _progressColor;
@synthesize badgeColor = _badgeColor;

@synthesize stringValue = _stringValue;
@synthesize progress = _progress;
@synthesize badgeCount = _badgeCount;


#pragma mark - Creating an info bar view


- (instancetype)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    if (self) {
        
        [self private_init];
    }
    return self;
}


- (instancetype)initWithFrame:(NSRect)frameRect {
    
    self = [super initWithFrame:frameRect];
    if (self) {
        
        [self private_init];
    }
    return self;
}


- (void)private_init {
    
    _tasks = [NSMutableArray array];
    _stringValue = @"";
    _seperatorValue = @":";
    _progress = 0.0f;
    
    [self setUpUndeterminedProgressIndicator];
    
    [self setUpTextField];
    
    [self setNeedsUpdateConstraints:YES];
}


#pragma mark - Adding tasks


- (void)addTask:(SGInfoBarTask *)task {
  
    [self.tasks addObject:task];
    [self recalculateDrawings];
}


- (void)addTasks:(NSArray<SGInfoBarTask *> *)tasks {
    
    [self.tasks addObjectsFromArray:tasks];
    [self recalculateDrawings];
}


#pragma mark - Removing tasks


- (void)removeTask:(SGInfoBarTask *)task {
    
    if (task) {
        
        [self.tasks performSelector:@selector(removeObject:) withObject:task afterDelay:0.1f];
        //[self.tasks removeObject:task];
        [self performSelector:@selector(recalculateDrawings) withObject:nil afterDelay:0.2f];
        //[self recalculateDrawings];
    }
}


- (void)removeTasks:(NSArray<SGInfoBarTask *> *)tasks {
    
    [self.tasks performSelector:@selector(removeObjectsInArray:) withObject:tasks afterDelay:0.1f];
    //[self.tasks removeObjectsInArray:tasks];
    [self performSelector:@selector(recalculateDrawings) withObject:nil afterDelay:0.2f];
    //[self recalculateDrawings];
}


#pragma mark - Calculate drawings


- (void)recalculateDrawings {
    
    if (self.tasks.count > 0) {
        
        SGInfoBarTask *task = self.tasks.firstObject;
        if (!task.taskProgressDescription) {
            
            self.infoTextField.stringValue = [NSString stringWithFormat:@"%@ %@ %@", self.stringValue, self.seperatorValue, task.taskName];
        }
        else {
            
            self.infoTextField.stringValue = [NSString stringWithFormat:@"%@ %@ %@ | %@", self.stringValue, self.seperatorValue, task.taskName, task.taskProgressDescription];
        }
        
        self.badgeCount = self.tasks.count;
        self.labelConstraint.animator.constant = kSGTextFieldMaxMarign;
        [self.undeterminedProgressIndicator performSelector:@selector(startAnimation:) withObject:self afterDelay:0.15f];
        [self performSelector:@selector(hideProgressIndicator:) withObject:@(NO) afterDelay:0.15f];
    }
    else {
        
        self.badgeCount = 0;
        
        [self drawText];
        
        [self.undeterminedProgressIndicator performSelector:@selector(stopAnimation:) withObject:self afterDelay:0.1f];
        [self performSelector:@selector(hideProgressIndicator:) withObject:@(YES) afterDelay:0.1f];
        self.labelConstraint.animator.constant = kSGTextFieldMinMarign;
    }
    
    [self setNeedsUpdateConstraints:YES];
    [self setNeedsLayout:YES];
    [self setNeedsDisplay:YES];
}


- (void)drawText {
    
    NSString *value = self.stringValue;
    if (self.secondaryStringValue) {
        value = [NSString stringWithFormat:@"%@ %@ %@", self.stringValue, self.seperatorValue, self.secondaryStringValue];
    }
    self.infoTextField.stringValue = value;
}


#pragma mark - Change progress visibility


- (void)hideProgressIndicator:(NSNumber *)hide {
    
    self.undeterminedProgressIndicator.hidden = hide.boolValue;
    [self setNeedsUpdateConstraints:YES];
    [self setNeedsLayout:YES];
    [self setNeedsDisplay:YES];
}


#pragma mark - Drawing the view


- (void)drawRect:(NSRect)dirtyRect {
    
    // Drawing code here.
    [self drawInfoBarWithFrame:dirtyRect];
}


- (void)drawInfoBarWithFrame:(NSRect)frame {
    
    // outline drawing
    [self drawOutlineInFrame:frame];
    
    // fill drawing
    [self drawFillingInFrame:frame];
    
    // progress drawing
    if (_tasks.firstObject.determined) [self drawProgressInFrame:frame];
    
    // draw badge
    if (_badgeCount > 0) [self drawBadgeWithCount:_badgeCount inFrame:frame];
}


- (void)drawOutlineInFrame:(NSRect)frame {
    
    //// outline Drawing
    NSBezierPath* outlinePath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(NSMinX(frame), NSMinY(frame) + frame.size.height - 24, floor((frame.size.width) * 1.00000 + 0.5), 24) xRadius: 3 yRadius: 3];
    [self.outlineColor setFill];
    [outlinePath fill];
}


- (void)drawFillingInFrame:(NSRect)frame {
    
    NSBezierPath* fillPath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(NSMinX(frame) + 1, NSMinY(frame) + frame.size.height - 23, floor((frame.size.width - 1) * 0.99791 + 0.5), 22) xRadius: 3 yRadius: 3];
    [self.fillColor setFill];
    [fillPath fill];
}


- (void)drawProgressInFrame:(NSRect)frame {
    
    CGFloat progressLength = frame.size.width * _progress;
    NSBezierPath* progressPath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(1, 1, progressLength, 22) xRadius: 3 yRadius: 3];
    [self.progressColor setFill];
    [progressPath fill];
}


- (void)drawBadgeWithCount:(NSInteger)badgeCount inFrame:(NSRect)frame {
    
    //// badgeOutline Drawing
    NSBezierPath* badgeOutlinePath = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(NSMinX(frame) + frame.size.width - 21, NSMinY(frame) + frame.size.height - 19, 14, 14)];
    [self.badgeColor setFill];
    [badgeOutlinePath fill];
    
    [self drawBadgeTextWithCount:badgeCount inFrame:frame];
}


- (void)drawBadgeTextWithCount:(NSInteger)badgeCount inFrame:(NSRect)frame {
    
    //// Text Drawing
    NSRect textRect = NSMakeRect(NSMinX(frame) + frame.size.width - 21, NSMinY(frame) + frame.size.height - 19, 14, 14);
    {
        NSString* textContent = [NSString stringWithFormat:@"%lu", _badgeCount];;
        NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle alloc] init];
        textStyle.alignment = NSTextAlignmentCenter;
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [NSFont systemFontOfSize: NSFont.smallSystemFontSize], NSForegroundColorAttributeName: self.fillColor, NSParagraphStyleAttributeName: textStyle};
        
        CGFloat textTextHeight = [textContent boundingRectWithSize: textRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes].size.height;
        NSRect textTextRect = NSMakeRect(NSMinX(textRect), NSMinY(textRect) + (textRect.size.height - textTextHeight) / 2, textRect.size.width, textTextHeight);
        [NSGraphicsContext saveGraphicsState];
        NSRectClip(textRect);
        [textContent drawInRect: NSOffsetRect(textTextRect, 0, 0) withAttributes: textFontAttributes];
        [NSGraphicsContext restoreGraphicsState];
    }
}


#pragma mark - Setup methodes


- (void)setUpUndeterminedProgressIndicator {
    
    NSProgressIndicator *progress = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
    progress.style = NSProgressIndicatorStyleSpinning;
    progress.displayedWhenStopped = NO;
    progress.controlSize = NSControlSizeSmall;
    [self addSubview:progress];
    progress.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintWithItem:progress
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:5.0f].active = YES;
    
    [NSLayoutConstraint constraintWithItem:progress
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0f].active = YES;
    self.undeterminedProgressIndicator = progress;
}


- (void)setUpTextField {
    
    NSTextField *textField = [[NSTextField alloc] initWithFrame:self.bounds];
    textField.bordered = NO;
    textField.stringValue = @"";
    textField.editable = NO;
    textField.selectable = NO;
    textField.drawsBackground = NO;
    textField.textColor = [NSColor controlTextColor];
    textField.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:textField];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintWithItem:textField
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0f].active = YES;
    
    self.labelConstraint = [NSLayoutConstraint constraintWithItem:textField
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:kSGTextFieldMinMarign];
    self.labelConstraint.active = YES;
    [NSLayoutConstraint constraintWithItem:textField
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:-30.0f].active = YES;
    self.infoTextField = textField;
}


#pragma mark - Setter


- (void)setOutlineColor:(NSColor *)outlineColor {
    
    _outlineColor = outlineColor;
    [self setNeedsDisplay:YES];
}


- (void)setFillColor:(NSColor *)fillColor {
    
    _fillColor = fillColor;
    [self setNeedsDisplay:YES];
}


- (void)setProgressColor:(NSColor *)progressColor {
    
    _progressColor = progressColor;
    [self setNeedsDisplay:YES];
}


- (void)setBadgeColor:(NSColor *)badgeColor {
    
    _badgeColor = badgeColor;
    [self setNeedsDisplay:YES];
}


- (void)setStringValue:(NSString *)stringValue {
    
    _stringValue = stringValue;
    [self drawText];
}

- (void)setSecondaryStringValue:(NSString *)secondaryStringValue {
    
    _secondaryStringValue = secondaryStringValue;
    [self drawText];
}

- (void)setSeperatorValue:(NSString *)seperatorValue {
    
    _seperatorValue = seperatorValue;
    [self drawText];
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    [self setNeedsDisplay:YES];
}


- (void)setBadgeCount:(NSUInteger)badgeCount {
    
    _badgeCount = badgeCount;
    [self setNeedsDisplay:YES];
}


#pragma mark - Getter/Lazy


- (NSColor *)outlineColor {
    
    if (!_outlineColor) {
        
        _outlineColor = [NSColor disabledControlTextColor];
    }
    return _outlineColor;
}


- (NSColor *)fillColor {
    
    if (!_fillColor) {
        _fillColor = [NSColor controlBackgroundColor];
    }
    return _fillColor;
}


- (NSColor *)progressColor {
    
    if (!_progressColor) {
        _progressColor = [NSColor colorWithRed: 0.92 green: 0.952 blue: 0.99 alpha: 1];
    }
    return _progressColor;
}


- (NSColor *)badgeColor {
    
    if (!_badgeColor) {
        //_badgeColor = [NSColor colorWithRed: 0.879 green: 0.373 blue: 0.373 alpha: 1];
        _badgeColor = [NSColor linkColor];
    }
    return _badgeColor;
}


#pragma mark -
@end
