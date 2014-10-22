//
//  ProjectListViewController.m
//  FilmSyncDemo
//
//  Created by Abdusha on 10/20/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "ProjectListViewController.h"
#import "AppDelegate.h"
#import "GCArraySectionController.h"

@interface ProjectListViewController ()

@property (nonatomic, retain) NSArray* retractableControllers;

@end

@implementation ProjectListViewController

@synthesize projectListArray = _projectListArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate addCenterButtonFromcontroller:self];
    [self configureView];
}

-(void) configureView
{
    GCArraySectionController* arrayController1 = [[GCArraySectionController alloc]
                                                 initWithArray:[NSArray arrayWithObjects:@"This", @"content", @"is", @"in", @"an", @"array", @"Enjoy", @"the", @"day", nil]
                                                 viewController:self];
    arrayController1.title = NSLocalizedString(@"Project 1",);
    GCArraySectionController* arrayController2 = [[GCArraySectionController alloc]
                                                 initWithArray:[NSArray arrayWithObjects:@"This", @"content", @"is", nil]
                                                 viewController:self];
    arrayController2.title = NSLocalizedString(@"Project 2",);
    GCArraySectionController* arrayController3 = [[GCArraySectionController alloc]
                                                 initWithArray:[NSArray arrayWithObjects:@"This", @"content", @"is", @"in", @"an", @"array", nil]
                                                 viewController:self];
    arrayController3.title = NSLocalizedString(@"Project 3",);
    GCArraySectionController* arrayController4 = [[GCArraySectionController alloc]
                                                  initWithArray:[NSArray arrayWithObjects:@"This", @"content", @"is", @"in", @"an", @"array",@"This", @"content", @"is", @"in", @"an", @"array", nil]
                                                  viewController:self];
    arrayController4.title = NSLocalizedString(@"Project 4",);
    GCArraySectionController* arrayController5 = [[GCArraySectionController alloc]
                                                  initWithArray:[NSArray arrayWithObjects:@"This", nil]
                                                  viewController:self];
    arrayController5.title = NSLocalizedString(@"Project 5",);
    GCArraySectionController* arrayController6 = [[GCArraySectionController alloc]
                                                  initWithArray:[NSArray arrayWithObjects:@"This", @"content", nil]
                                                  viewController:self];
    arrayController6.title = NSLocalizedString(@"Project 6",);
    self.retractableControllers = [NSArray arrayWithObjects:arrayController1, arrayController2, arrayController3, arrayController4,arrayController5,arrayController6, nil];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.retractableControllers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:section];
    return sectionController.numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    return [sectionController cellForRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    return [sectionController didSelectCellAtRow:indexPath.row];
}

- (void)dealloc
{
    self.retractableControllers = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
