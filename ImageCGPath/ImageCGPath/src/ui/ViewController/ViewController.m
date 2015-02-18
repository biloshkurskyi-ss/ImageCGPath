//
//  ViewController.m
//  ImageCGPath
//
//  Created by Serg on 2/18/15.
//  Copyright (c) 2015 Sergey Biloshkurskyi. All rights reserved.
//

#import "ViewController.h"
#import "AppState.h"
#import "ImageViewCGPath.h"

@interface ViewController () <UITextFieldDelegate>
{
    float scaleFactor;
    int imageXSize;
}

@property (nonatomic, weak) IBOutlet UITextField                *tfScaleKoeficient;
@property (nonatomic, strong) ImageViewCGPath                   *selectedImageView;
@property (nonatomic, strong) TempView                          *tempView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AppState sharedInstance] inialize];
    scaleFactor = 1;
    imageXSize = 1;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[AppState sharedInstance] imagePath].length > 0)
    {
        [self loadImageView];
    }
}

#pragma mark - Action Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:_selectedImageView];
    point.x = point.x / imageXSize;
    point.y = point.y / imageXSize;
    
    if (point.x > 0 || point.y > 0)
    {
         NSLog(@"point = %@",NSStringFromCGPoint(point));
        
        if (_selectedImageView.points == nil)
        {
            _selectedImageView.points = [NSMutableArray array];
        }
        
        [_selectedImageView.points addObject:[NSValue valueWithCGPoint:point]];
    }
    
    // point.x and point.y have the coordinates of the touch
}

-(IBAction)updateImageScaleFactor:(id)sender
{
    scaleFactor = [_tfScaleKoeficient.text floatValue];
    
    [self loadImageView];
}

-(IBAction)drawImagePath:(id)sender
{
    [_tempView removeFromSuperview];
    _tempView = nil;
    
    _tempView = [[TempView alloc] initWithFrame:_selectedImageView.frame];
    _tempView.backgroundColor = [UIColor clearColor];
    _tempView.points = _selectedImageView.points;
    _tempView.scaleXFactor = imageXSize;
    [self.view addSubview:_tempView];
    
    [_tempView setNeedsDisplay];
}

-(IBAction)RemoveImagePath:(id)sender
{
    [_tempView removeFromSuperview];
    _tempView = nil;
}

-(IBAction)clearAll:(id)sender
{
    [_selectedImageView.points removeAllObjects];
    [self RemoveImagePath:nil];
}

-(IBAction)printCoordinates:(id)sender
{
    [_selectedImageView printPoints];
}

-(void)loadImageView
{
    [_selectedImageView removeFromSuperview];
    _selectedImageView = nil;
    
    UIImage *selectedImage = [UIImage imageNamed:[[[AppState sharedInstance] imagePath] lastPathComponent]];
    
    _selectedImageView = [[ImageViewCGPath alloc] init];
    
    _selectedImageView.frame = CGRectMake(0, 0, selectedImage.size.width*scaleFactor, selectedImage.size.height*scaleFactor);
    _selectedImageView.center = self.view.center;
    _selectedImageView.backgroundColor = [UIColor brownColor];
    _selectedImageView.image = selectedImage;
    
    [_selectedImageView drawBorder];
    
    [self.view addSubview:_selectedImageView];
    
    [self.view sendSubviewToBack:_selectedImageView];
}

-(IBAction) segmentControlAction:(id)sender{
    NSLog(@"myAction",nil);
    
    UISegmentedControl * control = sender;
    imageXSize = [control selectedSegmentIndex];//@1x/@2x/@3x
}

@end
