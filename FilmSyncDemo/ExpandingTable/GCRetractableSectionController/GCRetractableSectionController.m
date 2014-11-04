//
//  GCRetractableSectionController.m
//  Mtl mobile
//
//  Created by Guillaume Campagna on 09-10-19.
//  Copyright 2009 LittleKiwi. All rights reserved.
//

#import "GCRetractableSectionController.h"

@interface GCRetractableSectionController ()

@property (nonatomic, assign) UIViewController *viewController;

- (void) setAccessoryViewOnCell:(UITableViewCell*) cell;

@end

@implementation GCRetractableSectionController

@synthesize useOnlyWhiteImages, titleTextColor, titleAlternativeTextColor;
@synthesize viewController;
@synthesize open, rowAnimation;

#pragma mark -
#pragma mark Initialisation

- (id) initWithViewController:(UIViewController*) givenViewController {
	if ((self = [super init])) {
        if (![givenViewController respondsToSelector:@selector(tableView)]) {
            //The view controller MUST have a tableView proprety
            [NSException raise:@"Wrong view controller" 
                        format:@"The passed view controller to GCRetractableSectionController must respond to the tableView proprety"];
        }
        
		self.viewController = givenViewController;
		self.open = NO;
        self.useOnlyWhiteImages = NO;
        self.rowAnimation = UITableViewRowAnimationTop;
        self.titleTextColor = [UIColor whiteColor];
        self.titleAlternativeTextColor = [UIColor lightGrayColor];
	}
	return self;
}

#pragma mark -
#pragma mark Getters

- (UITableView*) tableView {
	return [self.viewController performSelector:@selector(tableView)];
}

- (NSUInteger) numberOfRow {
    return (self.open) ? self.contentNumberOfRow + 1 : 1;
}

- (NSUInteger) contentNumberOfRow {
	return 0;
}

- (NSString*) title {
	return NSLocalizedString(@"No title",);
}

- (NSString*) titleContentForRow:(NSUInteger) row {
	return NSLocalizedString(@"No title",);
}

#pragma mark -
#pragma mark Cells

- (UITableViewCell *) cellForRow:(NSUInteger)row {
	UITableViewCell* cell = nil;
	
	if (row == 0) cell = [self titleCell];
	else cell = [self contentCellForRow:row - 1];
	
	return cell;
}

- (UITableViewCell *) titleCell {
	//NSString* titleCellIdentifier = [NSStringFromClass([self class]) stringByAppendingString:@"title"];
    NSString* titleCellIdentifier = @"title";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
	if (cell == nil) {
		//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:titleCellIdentifier] autorelease];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:titleCellIdentifier];
        
        //Separator
        /*UIImage *sepImg = [UIImage imageNamed:@"sep.png"];
        UIImageView *sepImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, cell.contentView.frame.size.width, 2)];
        [sepImgV setImage:sepImg];
        [cell.contentView addSubview:sepImgV];*/
        
        //[cell.textLabel setNumberOfLines:2];
        //cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //[cell.textLabel setFrame:CGRectMake(0, 0, cell.contentView.frame.size.width - 60, cell.contentView.frame.size.height)];
        //[cell.detailTextLabel setFont:[UIFont systemFontOfSize:8.0]];
        //[cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
	}
    
    UILabel *titleLbl = (UILabel *)[cell viewWithTag:1003];
    UILabel *cardCountLbl = (UILabel *)[cell viewWithTag:1004];
	
	titleLbl.text = self.title;
	if (self.contentNumberOfRow >= 2) {
		cardCountLbl.text = [NSString stringWithFormat:NSLocalizedString(@"%i Cards",), self.contentNumberOfRow];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setAccessoryViewOnCell:cell];
	}
    else if (self.contentNumberOfRow == 1)
    {
        cardCountLbl.text = [NSString stringWithFormat:NSLocalizedString(@"1 Card",)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setAccessoryViewOnCell:cell];
    }
	else {
		cardCountLbl.text = NSLocalizedString(@"No Card",);
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = nil;
        titleLbl.textColor = [UIColor blackColor];
	}
    [cell setBackgroundColor:[UIColor clearColor]];
	return cell;
}

- (UITableViewCell *) contentCellForRow:(NSUInteger)row {
	//NSString* contentCellIdentifier = [NSStringFromClass([self class]) stringByAppendingString:@"content"];
	NSString* contentCellIdentifier =@"content";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
	if (cell == nil) {
		//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:contentCellIdentifier] autorelease];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:contentCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.indentationLevel = 1;
        
        //Separator
        /*
        UIImage *sepImg = [UIImage imageNamed:@"sep.png"];
        UIImageView *sepImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, cell.contentView.frame.size.width, 2)];
        [sepImgV setImage:sepImg];
        sepImgV.translatesAutoresizingMaskIntoConstraints = NO;
        //[sepImgV setBackgroundColor:[UIColor blackColor]];
        [sepImgV setTag:2];
        [cell.contentView addSubview:sepImgV];
        
        ////[sepImgV addConstraints:[NSLayoutConstraint
                                 constraintsWithVisualFormat:@"V:[cell]-offsetTop-[sepImgV]"
                                 options:0
                                 metrics:@{@"offsetTop": @49}
                                 views:NSDictionaryOfVariableBindings(sepImgV,cell)]];///
        [sepImgV addConstraint:[NSLayoutConstraint constraintWithItem:sepImgV
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:cell.contentView
                                                             attribute:NSLayoutAttributeLeadingMargin
                                                            multiplier:0
                                                              constant:-6.0]];
        [sepImgV addConstraint:[NSLayoutConstraint constraintWithItem:sepImgV
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:cell.contentView
                                                            attribute:NSLayoutAttributeTrailingMargin
                                                           multiplier:0
                                                             constant:-6.0]];
        [sepImgV addConstraint:[NSLayoutConstraint constraintWithItem:sepImgV
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:cell.contentView
                                                            attribute:NSLayoutAttributeTopMargin
                                                           multiplier:0
                                                             constant:49]];
        [sepImgV addConstraint:[NSLayoutConstraint constraintWithItem:sepImgV
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:cell.contentView
                                                            attribute:NSLayoutAttributeBottomMargin
                                                           multiplier:0
                                                             constant:0]];*/
        /*
        "<NSLayoutConstraint:0x79e3f410 UILabel:0x79e41f70'Project List Screen'.leading == UIView:0x7b2297b0.leadingMargin - 6>",
        "<NSLayoutConstraint:0x79e3f470 UIView:0x7b2297b0.trailingMargin == UILabel:0x79e41f70'Project List Screen'.trailing - 6>",
        "<NSLayoutConstraint:0x79e3f4a0 UIView:0x7b2297b0.centerX == UILabel:0x79e41f70'Project List Screen'.centerX>"*/
        
        
        //<NSLayoutConstraint:0x7a9b6580 UILabel:0x7ac80790'Project List Screen'.leading == UIView:0x7a9b22d0.leadingMargin - 6>",
	}
   // UIImageView *sepImgV = (UIImageView *)[cell viewWithTag:2];
    //[sepImgV setFrame:CGRectMake(0, 49, cell.contentView.frame.size.width, 2)];
    
	//cell.textLabel.textColor =[UIColor colorWithRed:55 green:100 blue:125 alpha:1];
	cell.textLabel.text = [self titleContentForRow:row];
	return cell;
}

- (void) setAccessoryViewOnCell:(UITableViewCell*) cell {
	NSString* path = nil;
	if (self.open) {
		path = @"UpAccessory";
        if (self.titleAlternativeTextColor == nil) cell.textLabel.textColor =  [UIColor colorWithRed:0.191 green:0.264 blue:0.446 alpha:1.000];
        else cell.textLabel.textColor = self.titleAlternativeTextColor;
	}	
	else {
		path = @"DownAccessory";
		cell.textLabel.textColor = (self.titleTextColor == nil ? [UIColor blackColor] : self.titleTextColor);
	}
	
	UIImage* accessoryImage = [UIImage imageNamed:path];
	UIImage* whiteAccessoryImage = [UIImage imageNamed:[[path stringByDeletingPathExtension] stringByAppendingString:@"White"]];
	
	UIImageView* imageView;
	if (cell.accessoryView != nil) {
		imageView = (UIImageView*) cell.accessoryView;
		imageView.image = (self.useOnlyWhiteImages ? whiteAccessoryImage : accessoryImage);
		imageView.highlightedImage = whiteAccessoryImage;
    }
	else {
		imageView = [[UIImageView alloc] initWithImage:(self.useOnlyWhiteImages ? whiteAccessoryImage : accessoryImage)];
		imageView.highlightedImage = whiteAccessoryImage;
		cell.accessoryView = imageView;
		//[imageView release];
        
	}
}

#pragma mark -
#pragma mark Select Cell

- (void) didSelectCellAtRow:(NSUInteger)row {
	if (row == 0) [self didSelectTitleCell];
	else [self didSelectContentCellAtRow:row - 1];
}

- (void) didSelectTitleCell {
	self.open = !self.open;
	if (self.contentNumberOfRow != 0) [self setAccessoryViewOnCell:[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]]];
	
	NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
	NSUInteger section = indexPath.section;
	NSUInteger contentCount = self.contentNumberOfRow;
	
	[self.tableView beginUpdates];
	
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (self.open) [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:self.rowAnimation];
	else [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:self.rowAnimation];
	//[rowToInsert release];
	
	[self.tableView endUpdates];
	
	if (self.open) [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) didSelectContentCellAtRow:(NSUInteger)row
{

}

@end
