//
//  ImageViewCGPath.h
//  ImageCGPath
//
//  Created by Serg on 2/18/15.
//  Copyright (c) 2015 Sergey Biloshkurskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewCGPath : UIImageView

@property (nonatomic, strong) NSMutableArray *points;

- (void)drawBorder;
- (void)printPoints;

@end

@interface TempView : UIView

@property (nonatomic, strong) NSMutableArray    *points;
@property (nonatomic)           NSInteger       scaleXFactor;

@end