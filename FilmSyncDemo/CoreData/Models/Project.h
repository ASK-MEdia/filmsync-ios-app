//
//  Project.h
//  FilmSyncDemo
//
//  Created by Abdusha on 10/22/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * credits;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * externalURL;
@property (nonatomic, retain) NSString * projectID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * twitterSearch;
@property (nonatomic, retain) NSSet *card;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addCardObject:(Card *)value;
- (void)removeCardObject:(Card *)value;
- (void)addCard:(NSSet *)values;
- (void)removeCard:(NSSet *)values;

-(NSArray *)sortedCards;
@end
