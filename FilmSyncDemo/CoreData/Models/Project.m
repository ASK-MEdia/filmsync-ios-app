//
//  Project.m
//  FilmSyncDemo
//
//  Created by Abdusha on 10/22/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "Project.h"
#import "Card.h"


@implementation Project

@dynamic credits;
@dynamic desc;
@dynamic externalURL;
@dynamic projectID;
@dynamic title;
@dynamic twitterSearch;
@dynamic card;


-(NSArray *)sortedCards {
    NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor, nil];
    
    return [(NSSet*)self.card sortedArrayUsingDescriptors:sortDescriptors];
}

@end
