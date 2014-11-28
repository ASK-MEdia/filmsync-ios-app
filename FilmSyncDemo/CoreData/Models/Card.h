//
//  Card.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/22/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * cardID;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Project *project;

@end
