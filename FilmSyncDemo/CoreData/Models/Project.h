//
//  Project.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/20/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * projectID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * credits;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * externalURL;
@property (nonatomic, retain) NSString * twitterSearch;
@property (nonatomic, retain) NSSet *card;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addCardObject:(NSManagedObject *)value;
- (void)removeCardObject:(NSManagedObject *)value;
- (void)addCard:(NSSet *)values;
- (void)removeCard:(NSSet *)values;

@end
