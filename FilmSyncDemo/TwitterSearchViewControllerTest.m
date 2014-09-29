//
//  TwitterSearchViewControllerTest.m
//  FilmSyncDemo
//
//  Created by Abdusha on 9/23/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "TwitterSearchViewControllerTest.h"
#import "SWRevealViewController.h"

@interface TwitterSearchViewControllerTest ()

@end

@implementation TwitterSearchViewControllerTest

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
                 
                 NSURL *requestURL = [NSURL URLWithString:
                                      @"https://api.twitter.com/1.1/search/tweets.json?q=%40apple"];
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
                              
                              [self.tweetTableView reloadData];
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
    
    
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"Hello a Tweet"];
    
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

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
}

@end
