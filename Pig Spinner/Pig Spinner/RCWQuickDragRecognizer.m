//
//  RCWQuickDragRecognizer.m
//  Pig Spinner
//
//  Created by Jonathan on 1/1/14.
//  Copyright (c) 2014 Rubber City Wizards. All rights reserved.
//

#import "RCWQuickDragRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation RCWQuickDragRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateBegan;
}

@end
