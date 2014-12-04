//
//  ProjectListViewController.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/20/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface ProjectListViewController : GAITrackedViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_projectListArray;  // store Project objects
}

@property (nonatomic,strong)  NSMutableArray *projectListArray; // store Project objects
@property (weak, nonatomic) IBOutlet UITableView *tableView; // Project listing table

@end
