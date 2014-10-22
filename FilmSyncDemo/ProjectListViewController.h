//
//  ProjectListViewController.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/20/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_projectListArray;
}

@property (nonatomic,strong)  NSMutableArray *projectListArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
