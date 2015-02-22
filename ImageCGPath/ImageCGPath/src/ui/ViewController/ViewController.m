//
//  ViewController.m
//  ImageCGPath
//
//  Created by Serg on 2/18/15.
//  Copyright (c) 2015 Sergey Biloshkurskyi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "ViewController.h"
#import "AppState.h"
#import "ImageViewCGPath.h"
#import "MainScen.h"

@interface ViewController () <UITextFieldDelegate>
{
    float   scaleFactor;
    int     imageXSize;
}

@property (nonatomic, weak) IBOutlet UITextField                *tfScaleKoeficient;
@property (nonatomic, strong) ImageViewCGPath                   *selectedImageView;
@property (nonatomic, strong) TempView                          *tempView;
@property (nonatomic, strong) SKView                            *spriteView;
@property (nonatomic, strong) MainScen                          *mainScen;
@property (nonatomic, strong) SKSpriteNode                      *imageSpriteNode;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AppState sharedInstance] inialize];
    scaleFactor = 1;
    imageXSize = 1;
    
    _spriteView = [[SKView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_spriteView];
    _spriteView.showsDrawCount = YES;
    _spriteView.showsNodeCount = YES;
    _spriteView.showsFPS = YES;
    
    _mainScen = [[MainScen alloc] initWithSize:[UIScreen mainScreen].bounds.size];
    _mainScen.scaleMode = SKSceneScaleModeAspectFill;
    _mainScen.name = @"MainScen";
    [_spriteView presentScene:_mainScen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if ([[AppState sharedInstance] imagePath].length > 0)
    {
        //[self loadImageView];//UIView
        [self loadSpriteKitView];//SpriteKit
    }
}

#pragma mark - Action Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    
    CGPoint point = CGPointZero;
    
    if (_imageSpriteNode)
    {
        point = [aTouch locationInNode:_imageSpriteNode];
    }
    else if (_selectedImageView)
    {
        point = [aTouch locationInView:_selectedImageView];
        point.x = point.x / imageXSize;
        point.y = point.y / imageXSize;
    }
    
    if ([self pointEqualToPoint:point withPoint:CGPointZero] != YES)
    {
        if (point.x > 0 || point.y > 0)
        {
            if (_selectedImageView == nil)
            {
                _selectedImageView = [[ImageViewCGPath alloc] init];
            }
            
            NSLog(@"point = %@",NSStringFromCGPoint(point));
            
            if (_selectedImageView.points == nil)
            {
                _selectedImageView.points = [NSMutableArray array];
            }
            
            [_selectedImageView.points addObject:[NSValue valueWithCGPoint:point]];
        }
    }
}

-(BOOL)pointEqualToPoint:(CGPoint) point1 withPoint:(CGPoint)point2
{
    return point1.x == point2.x && point1.y == point2.y;
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

-(IBAction) segmentControlAction:(id)sender
{
    UISegmentedControl * control = sender;
    imageXSize = [control selectedSegmentIndex];//@1x/@2x/@3x
}

#pragma mark - Private

-(void)loadSpriteKitView
{
    [_mainScen removeAllChildren];
    
    [_mainScen setBackgroundColor:[UIColor whiteColor]];
    
    NSString *imageName = [[[AppState sharedInstance] imagePath] lastPathComponent];
    UIImage *imageWithName = [UIImage imageNamed:imageName];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    float imageScaleFactor = [self scaleFactorForString:imageName];
    CGSize size = CGSizeMake(imageWithName.size.width/imageScaleFactor, imageWithName.size.height/imageScaleFactor);
    
    _imageSpriteNode = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:size];
    [_imageSpriteNode setTexture:texture];
    
    _imageSpriteNode.position = CGPointMake(CGRectGetMidX(_mainScen.frame) - size.width/2, CGRectGetMidY(_mainScen.frame));
    _imageSpriteNode.anchorPoint = CGPointMake(0, 0);
    NSLog(@"position = %@\nframe = %@",NSStringFromCGPoint(_imageSpriteNode.position),NSStringFromCGRect(_imageSpriteNode.frame));
    
    [_mainScen addChild:_imageSpriteNode];
}

-(float)scaleFactorForString:(NSString*)string
{
    if ([string rangeOfString:@"@3x"].location != NSNotFound)
    {
        return 3.0;
    }
    else if ([string rangeOfString:@"@2x"].location != NSNotFound)
    {
        return 2.0f;
    }
    else
    {
        return 1;
    }
}

@end
