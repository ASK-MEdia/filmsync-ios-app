//
//  Card.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/20/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSNumber * cardID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) Project *project;

@end
