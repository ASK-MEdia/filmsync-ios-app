//
//  TwitterSearchViewController.m
//  FilmSyncDemo
//
//  Created by Abdusha on 9/23/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "TwitterSearchViewController.h"
#import "SWRevealViewController.h"
#import "TweetCell.h"
#import "Utils.h"


CGFloat kCollectionFeedWidthPortrait = 310;
CGFloat kCollectionFeedWidthLandscape = 320;

@interface TwitterSearchViewController ()


@property (strong, atomic) NSMutableDictionary *imagesDictionary;

@end

@implementation TwitterSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Twitter";
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self getTimeLine];
    
    // Change button color
    _tweetButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _tweetButton.target = self;
    _tweetButton.action = @selector(showTweetView);
    
    self.imagesDictionary = [NSMutableDictionary dictionary];
    
    /*
    CGFloat width = kCollectionFeedWidthPortrait;
    NSInteger colCount = 2;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(20, 12, 20, 12);
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        width = kCollectionFeedWidthLandscape;
        colCount = 3;
        sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    }
    
    UICollectionViewWaterfallLayout *layout = [[UICollectionViewWaterfallLayout alloc] init];
    
    layout.sectionInset = sectionInset;
    layout.delegate = self;
    layout.itemWidth = width;
    layout.columnCount = colCount;
    self.collectionView.collectionViewLayout = layout;*/
    //UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
    //self.collectionView.collectionViewLayout = layout;
    
    // Configure layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(310, 80)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0.0f;
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    
    
    NSLog(@"Fonts :%@",[UIFont familyNames] );
    NSLog (@"Courier New family fonts: %@", [UIFont fontNamesForFamilyName:@"Arial"]);
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTwitterData) name:AccountTwitterAccessGranted object:nil];
    
    //TwitterAdapter* twitterAdapter = [AppDelegate instance].twitterAdapter;
    //[twitterAdapter accessTwitterAccountWithAccountStore:[AppDelegate instance].accountStore];
    
    //[self setupCollectionView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*if (self.dataSource.count != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[self.tweetTableView reloadData];
            [self.collectionView reloadData];
        });
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getTimeLine {
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 
                 NSLog(@"userFullName %@", twitterAccount.userFullName);
                 NSLog(@"username %@", twitterAccount.username);
                 NSLog(@"credential %@", twitterAccount.credential);
                 NSLog(@"identifier %@", twitterAccount.identifier);
                 
                 NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json?q=%40FTS_Mob"];
                 //NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json?q=%40FTS_Mob"];
                 //%23john%20OR%20%40apple%20OR%20
                 //@"https://api.twitter.com/1.1/search/tweets.json?q=%40twitterapi"
                 /*
                  NSURL *requestURL = [NSURL URLWithString:
                  @"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                  
                  NSDictionary *parameters =
                 @{@"screen_name" : @"@FilmSyncApp",
                   @"include_rts" : @"0",
                   @"trim_user" : @"1",
                   @"count" : @"20"};
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:parameters];
                 */
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:nil];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      
                      NSDictionary *resultDict = [NSJSONSerialization
                                                  JSONObjectWithData:responseData
                                                  options:NSJSONReadingMutableLeaves
                                                  error:&error];
                      
                      NSLog(@"resultDict :%@",resultDict);
                      self.dataSource = resultDict[@"statuses"];
                      
                      
                      if (self.dataSource.count != 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              //[self.tweetTableView reloadData];
                              [self.collectionView reloadData];
                          });
                      }
                  }];
             }
         } else {
             // Handle failure to get account access
         }
         
         NSLog(@"granted :%d",granted);
         NSLog(@"error :%@",error);
     }];
}

-(void) showTweetView
{
    [self.collectionView reloadData];
    
     SLComposeViewController *tweetSheet = [SLComposeViewController
     composeViewControllerForServiceType:SLServiceTypeTwitter];
     [tweetSheet setInitialText:@"@FTS_Mob Hello a Tweet"];
     
     [self presentViewController:tweetSheet animated:YES completion:nil];
}
/*
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tweetTableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *tweet = _dataSource[[indexPath row]];
    
    cell.textLabel.text = tweet[@"text"];
    return cell;
}*/


#pragma mark - UICollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = (TweetCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TweetCell" forIndexPath:indexPath];

    CGRect CellRect = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, kCollectionFeedWidthPortrait, [self heightForCellAtIndex:indexPath.row]);
    [cell setFrame:CellRect];
    NSDictionary *tweetDictionary = self.dataSource[indexPath.row];
    
    NSDictionary *user = tweetDictionary[@"user"];
    
    
    cell.usernameLabel.text = user[@"name"];
    NSString *tweetText = tweetDictionary[@"text"];
    cell.tweetLabel.text = tweetText;
    CGFloat ht = [self heightForCellAtIndex:indexPath.row] - 32.0f;
    CGRect tweetLblRect = CGRectMake(cell.tweetLabel.frame.origin.x,cell.tweetLabel.frame.origin.y,cell.bounds.size.width - 94,ht);
    [cell.tweetLabel setFrame:tweetLblRect];
    //cell.tweetLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    cell.tweetLabel.font = [UIFont fontWithName:@"ArialMT" size:13.0f] ;//[UIFont systemFontOfSize:13.0f];
    
    
    NSLog(@"tweetText :%@",tweetText);
    NSLog(@"tweetText :%f",cell.tweetLabel.frame.size.height);

    NSString *userName = user[@"name"];
    cell.profileImageView.image = nil;
    
    if (self.imagesDictionary[userName]) {
        cell.profileImageView.image = self.imagesDictionary[userName];
    } else {
        NSString* imageUrl = [user objectForKey:@"profile_image_url"];
        
        [self getImageFromUrl:imageUrl asynchronouslyForImageView:cell.profileImageView andKey:userName];
    }
    
    NSArray *days = [NSArray arrayWithObjects:@"Mon ", @"Tue ", @"Wed ", @"Thu ", @"Fri ", @"Sat ", @"Sun ", nil];
    NSArray *calendarMonths = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar",@"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    NSString *dateStr = [tweetDictionary objectForKey:@"created_at"];
    
    for (NSString *day in days) {
        if ([dateStr rangeOfString:day].location == 0) {
            dateStr = [dateStr stringByReplacingOccurrencesOfString:day withString:@""];
            break;
        }
    }
    
    NSArray *dateArray = [dateStr componentsSeparatedByString:@" "];
    NSArray *hourArray = [[dateArray objectAtIndex:2] componentsSeparatedByString:@":"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSString *aux = [dateArray objectAtIndex:0];
    int month = 0;
    for (NSString *m in calendarMonths) {
        month++;
        if ([m isEqualToString:aux]) {
            break;
        }
    }
    components.month = month;
    components.day = [[dateArray objectAtIndex:1] intValue];
    components.hour = [[hourArray objectAtIndex:0] intValue];
    components.minute = [[hourArray objectAtIndex:1] intValue];
    components.second = [[hourArray objectAtIndex:2] intValue];
    components.year = [[dateArray objectAtIndex:4] intValue];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneForSecondsFromGMT:2];
    [components setTimeZone:gmt];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [calendar dateFromComponents:components];
    
    cell.dateLabel.text = [Utils getTimeAsString:date];

    return cell;
}


#pragma mark - UICollectionView delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = kCollectionFeedWidthPortrait;
    /*if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        width = kCollectionFeedWidthLandscape;
    }*/
    return CGSizeMake(width, [self heightForCellAtIndex:indexPath.row]);
}

/*
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"heightForItemAtIndexPath");
    
    return [self heightForCellAtIndex:indexPath.row];
}*/



- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    /*
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        return UIEdgeInsetsMake(20, 10, 20, 10);
    }
    else{
        return UIEdgeInsetsMake(20, 12, 20, 12);
    }*/
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
/*
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //[self setupCollectionView];
}*/
/*
- (void)setupCollectionView {
    
    CGFloat width = kCollectionFeedWidthPortrait;
    NSInteger colCount = 2;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(20, 12, 20, 12);
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        width = kCollectionFeedWidthLandscape;
        colCount = 3;
        sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    }
    UICollectionViewWaterfallLayout *layout = (UICollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.itemWidth = width;
    layout.columnCount = 1;
    layout.sectionInset = UIEdgeInsetsMake(20, 12, 20, 12);
    [self.collectionView reloadData];
}
*/

- (CGFloat)heightForCellAtIndex:(NSUInteger)index {
    
    NSDictionary *tweet = self.dataSource[index];
    CGFloat cellHeight = 32;
    NSString *tweetText = tweet[@"text"];
    //NSLog(@"** tweetText :%@**",tweetText);
   // NSLog(@"## tweetText :%@##",tweetText);
    CGFloat width = kCollectionFeedWidthPortrait;
    /*if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        width = kCollectionFeedWidthLandscape;
    }*/
    //CGSize labelHeight = [tweetText sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(width - 84, 4000)];
    
    //cellHeight += labelHeight.height;
    
    CGSize maximumLabelSize = CGSizeMake(width - 94, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin;
    
    //NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]};
    NSDictionary *attr = @{NSFontAttributeName: [UIFont fontWithName:@"ArialMT" size:13.0f]};
    CGRect labelBounds = [tweetText boundingRectWithSize:maximumLabelSize
                                              options:options
                                           attributes:attr
                                              context:nil];
    
    CGFloat lblHeight = ceilf(labelBounds.size.height);
    //NSLog(@"cellHeight :%f lblHeight:%f labelBounds.height:%f labelHeight:%f",cellHeight,lblHeight,labelBounds.size.height,labelHeight.height);
    
    cellHeight += lblHeight;
    //NSLog(@"Final cellHeight :%f",cellHeight);
    
    if (cellHeight < 80) {
        cellHeight = 80;
    }
    return cellHeight;
}

-(void)getImageFromUrl:(NSString*)imageUrl asynchronouslyForImageView:(UIImageView*)imageView andKey:(NSString*)key{
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:imageUrl];
        
        __block NSData *imageData;
        
        dispatch_sync(dispatch_get_global_queue(
                                                DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            imageData =[NSData dataWithContentsOfURL:url];
            
            if(imageData){
                
                [self.imagesDictionary setObject:[UIImage imageWithData:imageData] forKey:key];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    imageView.image = self.imagesDictionary[key];
                });
            }
        });
    });
}


@end
