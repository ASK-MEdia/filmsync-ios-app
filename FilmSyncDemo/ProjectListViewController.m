//
//  ProjectListViewController.m
//  FilmSyncDemo
//
//  Created by Abdusha on 10/20/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "ProjectListViewController.h"
#import "CardsViewControllerPOC.h"
#import "AppDelegate.h"
#import "GCArraySectionController.h"
#import "Project.h"
#import "Card.h"

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
    /*UIImage *ListIconImg = [UIImage imageNamed:@"tabIcon_ProjectList.png"];
    ListIconImg = [ListIconImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"List" image:ListIconImg selectedImage:ListIconImg];*/
    //[[UITabBar appearance] setTintColor:[UIColor redColor]];
    
    /*
    UIImage *musicImage = [UIImage imageNamed:@"tabIcon_ProjectList.png"];
    UIImage *musicImageSel = [UIImage imageNamed:@"tabIcon_ProjectList.png"];
    musicImage = [musicImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //musicImageSel = [musicImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    musicImageSel = [musicImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Music" image:musicImage selectedImage:musicImageSel];
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];*/
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureView];
    [self.tableView reloadData];
    
    NSLog(@"tableView contraints :%@",[self.tableView constraints]);
    
    //NSLog(@"CardsViewControllerPOC sharedInstance :%@",[CardsViewControllerPOC sharedInstance]);
    NSLog(@"CardsViewControllerPOC tab :%@",[self.tabBarController.viewControllers objectAtIndex:1]);
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
        /*
        NSMutableArray *cardsTitleArray = [[NSMutableArray alloc] init];
        for (Card *crd in prj.card)
        {
            [cardsTitleArray addObject:crd.title];
        }
        */
        NSArray *cardsArray = [prj.card allObjects];
        GCArraySectionController* projectController = [[GCArraySectionController alloc]
                                                      initWithArray:cardsArray
                                                      viewController:self];
        projectController.title = [NSString stringWithFormat:@"%@",prj.title];
        [projectControllersArray addObject:projectController];
        
    }
    
    /*
    GCArraySectionController* arrayController1 = [[GCArraySectionController alloc]
                                                 initWithArray:[NSArray arrayWithObjects:@"Card 1", @"Card 2", @"Card 3", @"Card 4", @"Card 5", @"Card 6", @"Card 7", @"Card 8", @"Card 9", nil]
                                                 viewController:self];
    arrayController1.title = NSLocalizedString(@"Project 1",);
    GCArraySectionController* arrayController2 = [[GCArraySectionController alloc]
                                                 initWithArray:[NSArray arrayWithObjects:@"Card 1", @"Card 2", @"Card 3", nil]
                                                 viewController:self];
    arrayController2.title = NSLocalizedString(@"Project 2",);
    GCArraySectionController* arrayController3 = [[GCArraySectionController alloc]
                                                 initWithArray:[NSArray arrayWithObjects:@"Card 1", @"Card 2", @"Card 3", @"Card 4", @"Card 5", @"Card 6", nil]
                                                 viewController:self];
    arrayController3.title = NSLocalizedString(@"Project 3",);
    GCArraySectionController* arrayController4 = [[GCArraySectionController alloc]
                                                  initWithArray:[NSArray arrayWithObjects:@"Card 1", @"Card 2", @"Card 3", @"Card 4", @"Card 5", @"Card 6",@"Card 7", @"Card 8", @"Card 9", @"Card 10", @"Card 11", @"Card 12", nil]
                                                  viewController:self];
    arrayController4.title = NSLocalizedString(@"Project 4",);
    GCArraySectionController* arrayController5 = [[GCArraySectionController alloc]
                                                  initWithArray:[NSArray arrayWithObjects:@"Card 1", nil]
                                                  viewController:self];
    arrayController5.title = NSLocalizedString(@"Project 5",);
    GCArraySectionController* arrayController6 = [[GCArraySectionController alloc]
                                                  initWithArray:[NSArray arrayWithObjects:@"Card 1", @"Card 2", nil]
                                                  viewController:self];
    arrayController6.title = NSLocalizedString(@"Project 6",);*/
    //self.retractableControllers = [NSArray arrayWithObjects:arrayController1, arrayController2, arrayController3, arrayController4,arrayController5,arrayController6, nil];
    self.retractableControllers = projectControllersArray;
    
}

#pragma mark - Tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.retractableControllers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:section];
    return sectionController.numberOfRow;
}
/*- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    // If you are not using ARC:
    // return [[UIView new] autorelease];
}*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    return [sectionController cellForRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *SelectedCardID = [NSString stringWithFormat:@"%012d",cell.tag];
    NSLog(@"SelectedCardID : %@",SelectedCardID);
    if (cell.tag > 0)
    {
        NSLog(@"CardsViewControllerPOC sharedInstance : %@",[CardsViewControllerPOC sharedInstance]);
        [self.tabBarController setSelectedIndex:1];
        [[CardsViewControllerPOC sharedInstance] newMarkerReceived:SelectedCardID];
        
    }
    
    
    
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    return [sectionController didSelectCellAtRow:indexPath.row];
}


- (NSMutableArray *)getAllProjectFromDatabase
{
    
    NSArray *result = nil;
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Project"];
    /*if ([entityName isEqualToString:@"Project"])
    {
        //Sort descending - new Logs will appear on the top row of the list
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"commentDate" ascending:NO]];
    }*/
    
    result = [[CoreData sharedManager] executeCoreDataFetchRequest:fetchRequest];
    /*
    NSLog(@"################################");
    NSLog(@"Projects :%@",result);
    for (Project *prj in result)
    {
         NSLog(@"Project ID :%@",prj.projectID);
         NSLog(@"Project title :%@",prj.title);
         NSLog(@"Project twitterSearch :%@",prj.twitterSearch);
         NSLog(@"Project decription :%@",prj.desc);
        for (Card *crd in prj.card)
        {
            NSLog(@"-------------------------");
            NSLog(@"Card ID :%@",crd.cardID);
            NSLog(@"Card title :%@",crd.title);
            NSLog(@"Card content :%@",crd.content);
            NSLog(@"Card ProjectID :%@",crd.project.projectID);
        }
        NSLog(@"################################");
    }*/
    /*
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"projectID = %@",@"19"];
    NSArray *filteredArray = [result filteredArrayUsingPredicate:predicate];
    NSLog(@"filteredArray :%@",filteredArray);*/
    
    
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
