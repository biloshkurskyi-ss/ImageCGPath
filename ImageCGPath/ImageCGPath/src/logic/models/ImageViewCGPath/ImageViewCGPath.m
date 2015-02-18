//
//  ImageViewCGPath.m
//  ImageCGPath
//
//  Created by Serg on 2/18/15.
//  Copyright (c) 2015 Sergey Biloshkurskyi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ImageViewCGPath.h"

@implementation ImageViewCGPath

- (void)drawBorder
{
    self.layer.cornerRadius = 0.0;
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    self.clipsToBounds = NO;
}

- (void)printPoints
{
    NSString *stringPath = @"";
    
    for (NSValue *val in _points)
    {
        CGPoint  p = [val CGPointValue];
        
        stringPath = [stringPath stringByAppendingString:[NSString stringWithFormat:@"%i,%i,",(int)p.x,(int)p.y]];
    }
    
    if ([stringPath length] > 0) {
        stringPath = [stringPath substringToIndex:[stringPath length] - 1];
    }
    
    NSLog(@"stringPath => \n%@",stringPath);
}

@end

@implementation TempView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 4.0);
    //CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    CGPoint pointStart;
    
    for (int i = 0 ; i < _points.count; i++)
    {
        CGPoint point = [[_points objectAtIndex:i] CGPointValue];
        
        point.x = point.x * _scaleXFactor;
        point.y = point.y * _scaleXFactor;
        
        if (i == 0)
        {
            pointStart = point;
            
            CGContextMoveToPoint(context,point.x,point.y);
        }
        else
        {
            CGContextAddLineToPoint(context,point.x,point.y);
        }
    }
    
    CGContextAddLineToPoint(context,pointStart.x,pointStart.y);
    CGContextSetFillColorWithColor(context,
                                   [UIColor redColor].CGColor);
    CGContextFillPath(context);
}

@end
