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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (![appDelegate isCenterButtonAdded])
    {//First time load
        //Add TabBar sync button
        [appDelegate addCenterButtonFromcontroller:self];
        
        //Launch to Sync screen
        [self.tabBarController setSelectedIndex:1];
    }
    else
    {
        //Configure Project List
        [self configureView];
        [self.tableView reloadData];
    }
    
}

// Configure Project list screen
-(void) configureView
{
    // Load project objects
    if (_projectListArray != nil)
    {
        _projectListArray = nil;
    }
    _projectListArray = [self getAllProjectFromDatabase];
    
    //Set Projects to custom expanding table cells
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

//select row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //retrive selected card id
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *SelectedCardID = [NSString stringWithFormat:@"%012d",cell.tag];
    
    if (cell.tag > 0)
    {
        //Load Sync tab
        [[CardsViewController sharedInstance] setCurrentCardID:SelectedCardID];
        [self.tabBarController setSelectedIndex:1];
        //[[CardsViewController sharedInstance] newMarkerReceived:SelectedCardID];
        
        
    }
    
    //Expanding table view support
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    return [sectionController didSelectCellAtRow:indexPath.row];
}

// load project from coredata
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


@end
