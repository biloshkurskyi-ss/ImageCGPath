//
//  AppState.m
//  ImageCGPath
//
//  Created by Serg on 2/18/15.
//  Copyright (c) 2015 Sergey Biloshkurskyi. All rights reserved.
//

#import "AppState.h"

@interface AppState ()
{
    NSArray *imagesList;
}

@end

@implementation AppState

+(AppState*)sharedInstance
{
    static AppState *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)inialize
{
    imagesList = [self recursivePathsForResourcesOfType:@"png" inDirectory:[[NSBundle mainBundle] bundlePath]];
}

#pragma mark - Public

-(NSArray*)imagesList
{
    return imagesList;
}

#pragma mark - Private methods

- (NSArray *)recursivePathsForResourcesOfType:(NSString *)type inDirectory:(NSString *)directoryPath{
    
    NSMutableArray *filePaths = [[NSMutableArray alloc] init];
    
    // Enumerators are recursive
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:directoryPath];
    
    NSString *filePath;
    
    while ((filePath = [enumerator nextObject]) != nil){
        
        // If we have the right type of file, add it to the list
        // Make sure to prepend the directory path
        if([[filePath pathExtension] isEqualToString:type]){
            [filePaths addObject:[directoryPath stringByAppendingPathComponent:filePath]];
        }
    }

    
    return filePaths;
}

@end
