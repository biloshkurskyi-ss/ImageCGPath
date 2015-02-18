//
//  AppState.h
//  ImageCGPath
//
//  Created by Serg on 2/18/15.
//  Copyright (c) 2015 Sergey Biloshkurskyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppState : NSObject

+(AppState*)sharedInstance;

@property (nonatomic, strong) NSString *imagePath;

-(void)inialize;
-(NSArray*)imagesList;

@end
