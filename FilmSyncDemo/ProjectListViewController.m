//
//  ProjectListViewController.m
//  FilmSyncDemo
//
//  Created by Abdusha on 10/20/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "ProjectListViewController.h"
#import "CardsViewController.h"
#import "AppDelegate.h"
#import "GCArraySectionController.h"
#import "Project.h"
#import "Card.h"

@interface ProjectListViewController ()

@property (nonatomic, retain) NSArray* retractableControllers;

@end

@implementation ProjectListViewController

@synthesize projectListArray = _projectListArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //Add TabBar sync button
    [appDelegate addCenterButtonFromcontroller:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Configure Project List
    [self configureView];
    [self.tableView reloadData];
    
    //NSLog(@"tableView contraints :%@",[self.tableView constraints]);
}

-(void) configureView
{
    if (_projectListArray != nil)
    {
        _projectListArray = nil;
    }
    _projectListArray = [self getAllProjectFromDatabase];
    NSMutableArray *projectControllersArray = [[NSMutableArray alloc] init];
    for (Project *prj in _projectListArray)
    {
        NSArray *cardsArray = [prj.card allObjects];
        GCArraySectionController* projectController = [[GCArraySectionController alloc]
                                                      initWithArray:cardsArray
                                                      viewController:self];
        projectController.title = [NSString stringWithFormat:@"%@",prj.title];
        [projectControllersArray addObject:projectController];
        
    }
    self.retractableControllers = projectControllersArray;
}

#pragma mark - Tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.retractableControllers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Expanding table view support
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:section];
    return sectionController.numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Expanding table view support
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    return [sectionController cellForRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //retrive selected card id
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *SelectedCardID = [NSString stringWithFormat:@"%012d",cell.tag];
    
    if (cell.tag > 0)
    {
        //Load Sync tab
        [self.tabBarController setSelectedIndex:1];
        [[CardsViewController sharedInstance] newMarkerReceived:SelectedCardID];
        
    }
    
    //Expanding table view support
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    return [sectionController didSelectCellAtRow:indexPath.row];
}


- (NSMutableArray *)getAllProjectFromDatabase
{
    NSArray *result = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Project"];
    
    //Sort
    /*if ([entityName isEqualToString:@"Project"])
    {
        //Sort descending - new Logs will appear on the top row of the list
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"commentDate" ascending:NO]];
    }*/
    
    result = [[CoreData sharedManager] executeCoreDataFetchRequest:fetchRequest];
    return [[NSMutableArray alloc]initWithArray:result];
    
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
