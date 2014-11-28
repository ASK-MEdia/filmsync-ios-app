//
//  GCArraySectionController.m
//  Demo
//
//  Created by Guillaume Campagna on 11-04-21.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import "GCArraySectionController.h"
#import "Card.h"

@interface GCArraySectionController ()

@property (nonatomic, retain) NSArray* content;

@end

@implementation GCArraySectionController

@synthesize content, title;

- (id)initWithArray:(NSArray *)array viewController:(UIViewController *)givenViewController {
    if ((self = [super initWithViewController:givenViewController])) {
        self.content = array;
    }
    return self;
}

#pragma mark -
#pragma mark Subclass

- (NSUInteger)contentNumberOfRow {
    return [self.content count];
}

- (NSString *)titleContentForRow:(NSUInteger)row
{
    Card *crd = [self.content objectAtIndex:row];
    return crd.title;
}

- (void)didSelectContentCellAtRow:(NSUInteger)row {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
}


#pragma mark -
#pragma mark Customization

- (UITableViewCell *)cellForRow:(NSUInteger)row {
    //All cells in the GCRetractableSectionController will be indented
    UITableViewCell* cell = [super cellForRow:row];
    
    //cell.indentationLevel = 1;
    
    return cell;
}

- (UITableViewCell *)titleCell {
    //I removed the detail text here, but you can do whatever you want
    UITableViewCell* titleCell = [super titleCell];
    //titleCell.detailTextLabel.text = nil;
    
    return titleCell;
}

- (UITableViewCell *)contentCellForRow:(NSUInteger)row {
    //You can reuse GCRetractableSectionController work by calling super, but you can start from scratch and give a new cell
    UITableViewCell* contentCell = [super contentCellForRow:row];
    
    Card *crd = [self.content objectAtIndex:row];
    contentCell.tag = [crd.cardID integerValue];
    /*
    if (row == 0) {
        contentCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        contentCell.accessoryView = nil;
        contentCell.backgroundColor = [UIColor whiteColor];
    }
    else if (row == 1) {
        contentCell.accessoryView = [[UISwitch alloc] init];
        contentCell.backgroundColor = [UIColor whiteColor];
    }
    else if (row == 2) {
        contentCell.backgroundColor = [UIColor blueColor];
        contentCell.accessoryView = nil;
        contentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }*/
    
    return contentCell;
}

- (void)dealloc {
    self.content = nil;
    self.title = nil;
    
    //[super dealloc];
}

@end
