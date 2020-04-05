//
//  ECInfoBar.m
//  Eventus Creo
//
//  Created by Simon Gaus on 27.11.18.
//  Copyright © 2018 Simon Gaus. All rights reserved.
//

#import "SGInfoBar.h"

#pragma mark - CONSTANTS


static CGFloat const kSGTextFieldMinMarign = 8.0f;
static CGFloat const kSGTextFieldMaxMarign = 25.0f;


#pragma mark - CATEGORIES


@interface SGInfoBar (/* Private */)

@property (nonatomic, strong) NSProgressIndicator *undeterminedProgressIndicator;
@property (weak, nonatomic) NSLayoutConstraint *labelConstraint;
@property (nonatomic, strong) NSTextField *infoTextField;
@property (nonatomic, strong) NSMutableArray<SGInfoBarTask *> *tasks;

@end


#pragma mark - IMPLEMENTATION


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
        [self performSelector:@selector(recalculateDrawings) withObject:nil afterDelay:0.2f];
    }
}

- (void)removeTasks:(NSArray<SGInfoBarTask *> *)tasks {
    if (tasks.count > 0) {
        [self.tasks performSelector:@selector(removeObjectsInArray:) withObject:tasks afterDelay:0.1f];
        [self performSelector:@selector(recalculateDrawings) withObject:nil afterDelay:0.2f];
    }
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
    
    [self drawBar:dirtyRect];
    [self drawBadge:dirtyRect];
}

- (void)drawBar:(NSRect)frame {
    
    // inset the drawing as the
    NSRect barDrawings = NSMakeRect(NSMinX(frame) + 0.5f, NSMinY(frame) + 0.5f, frame.size.width - 1.0f, frame.size.height - 1.0f);
    // get drawing parameters
    CGFloat cornerRadius = 5.0f;
    CGFloat minX = NSMinX(barDrawings);
    CGFloat minY = NSMinY(barDrawings);
    CGFloat adjustedWidth = floor(barDrawings.size.width + 0.5);
    CGFloat adjustedHeight = floor(barDrawings.size.height + 0.5);
    CGFloat progressWidth = floor(barDrawings.size.width * _progress + 0.5);
    
    //// fillRect Drawing
    NSBezierPath* fillRectPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(minX, minY, adjustedWidth, adjustedHeight) xRadius:cornerRadius yRadius:cornerRadius];
    [self.fillColor setFill];
    [fillRectPath fill];
    
    //// progressFillRect Drawing
    NSBezierPath* progressFillRectPath;
    if (progressWidth > 4.0f && progressWidth < frame.size.width-3.0f) {
        NSRect progressFillRectRect = NSMakeRect(minX, minY, progressWidth, adjustedHeight);
        NSRect progressFillRectInnerRect = NSInsetRect(progressFillRectRect, cornerRadius, cornerRadius);
        // draw path
        progressFillRectPath = [NSBezierPath bezierPath];
        [progressFillRectPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(progressFillRectInnerRect), NSMinY(progressFillRectInnerRect)) radius:cornerRadius startAngle:180 endAngle:270];
        [progressFillRectPath lineToPoint: NSMakePoint(NSMaxX(progressFillRectRect), NSMinY(progressFillRectRect))];
        [progressFillRectPath lineToPoint: NSMakePoint(NSMaxX(progressFillRectRect), NSMaxY(progressFillRectRect))];
        [progressFillRectPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(progressFillRectInnerRect), NSMaxY(progressFillRectInnerRect)) radius:cornerRadius startAngle:90 endAngle:180];
        [progressFillRectPath closePath];
    }
    else {
        progressFillRectPath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(minX, minY, progressWidth, adjustedHeight) xRadius:cornerRadius yRadius:cornerRadius];
    }
    [self.progressColor setFill];
    [progressFillRectPath fill];
    
    //// outlineRect Drawing
    [self.outlineColor setStroke];
    fillRectPath.lineWidth = 1;
    [fillRectPath stroke];
}

- (void)drawBadge:(NSRect)frame {
    
    if (_badgeCount == 0) {
        return;
    }
    
    CGFloat badgeWidth = [self widthFromBadgeCount:_badgeCount];
    
    //// Rectangle Drawing
    NSRect rectangleRect = NSMakeRect(NSMinX(frame) + frame.size.width - (badgeWidth+7), NSMinY(frame) + floor((frame.size.height - 14) * 0.50000 + 0.5), badgeWidth, 14);
    NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRoundedRect: rectangleRect xRadius: 7 yRadius: 7];
    [self.badgeColor setFill];
    [rectanglePath fill];
    {
        NSString* textContent = [NSString stringWithFormat:@"%lu", _badgeCount];
        NSMutableParagraphStyle* rectangleStyle = [[NSMutableParagraphStyle alloc] init];
        rectangleStyle.alignment = NSCenterTextAlignment;
        NSDictionary* rectangleFontAttributes = @{NSFontAttributeName: [NSFont fontWithName: @"HelveticaNeue" size: [NSFont systemFontSizeForControlSize: NSMiniControlSize]], NSForegroundColorAttributeName:self.fillColor, NSParagraphStyleAttributeName: rectangleStyle};
        
        CGFloat rectangleTextHeight = [textContent boundingRectWithSize: rectangleRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: rectangleFontAttributes].size.height;
        NSRect rectangleTextRect = NSMakeRect(NSMinX(rectangleRect), NSMinY(rectangleRect)-1.0f + (rectangleRect.size.height - rectangleTextHeight) / 2, rectangleRect.size.width, rectangleTextHeight);
        [NSGraphicsContext saveGraphicsState];
        NSRectClip(rectangleRect);
        [textContent drawInRect: NSOffsetRect(rectangleTextRect, 0, 3) withAttributes: rectangleFontAttributes];
        [NSGraphicsContext restoreGraphicsState];
    }
}

- (CGFloat)widthFromBadgeCount:(NSUInteger)badgeCount {
    
    CGFloat badgeWidth = 16.0f;
    
    if (_badgeCount >= 10) {
        badgeWidth = 21.0f;
    }
    if (_badgeCount >= 100) {
        badgeWidth = 26.0f;
    }
    if (_badgeCount >= 1000) {
        badgeWidth = 31.0f;
    }
    if (_badgeCount >= 10000) {
        badgeWidth = 35.0f;
    }
    if (_badgeCount >= 100000) {
        badgeWidth = 41.0f;
    }
    if (_badgeCount >= 1000000) {
        badgeWidth = 47.0f;
    }
    return badgeWidth;
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
    
    [textField setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    
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
        //_badgeColor = [NSColor colorWithRed: 0.879 green: 0.373 blue: 0.373 alpha:1];
        _badgeColor = [NSColor linkColor];
    }
    return _badgeColor;
}

#pragma mark -
@end
