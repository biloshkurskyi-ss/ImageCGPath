//
//  ImageListTableViewController.m
//  ImageCGPath
//
//  Created by Serg on 2/18/15.
//  Copyright (c) 2015 Sergey Biloshkurskyi. All rights reserved.
//

#import "ImageListTableViewController.h"
#import "AppState.h"

@interface ImageListTableViewController ()

@end

@implementation ImageListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[[AppState sharedInstance] imagesList] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageNameIdentifier"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageNameIdentifier"];
    }
    
    cell.textLabel.text = [[[[AppState sharedInstance] imagesList] objectAtIndex:indexPath.row] lastPathComponent];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [AppState sharedInstance].imagePath = [[[AppState sharedInstance] imagesList] objectAtIndex:indexPath.row];
    
    [[self navigationController] popViewControllerAnimated:YES];
}



@end
