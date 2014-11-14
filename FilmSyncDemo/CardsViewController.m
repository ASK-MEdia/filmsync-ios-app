//
//  CardsViewController.m
//  FilmSyncDemo
//
//  Created by Abdusha on 10/13/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "CardsViewController.h"
#import "AppDelegate.h"
#import "Project.h"
#import "Card.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "FilmSyncWebService.h"

@interface CardsViewController ()
{
    NSString *twitterTagsForCurrentProject;
}

@end

@implementation CardsViewController

@synthesize markerDataArray = _markerDataArray;

// *************** Singleton *********************

static CardsViewController *sharedInstance = nil;

#pragma mark -
#pragma mark Singleton Methods
+ (CardsViewController *)sharedInstance
{
    if (sharedInstance == nil)
    {
        //sharedInstance = [[CardsViewController alloc] init];
    }
    
    return sharedInstance;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sharedInstance = self;
    }
    return self;
}

#pragma mark - View lifecycle methos

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sharedInstance = self;
    
    _currentCard = nil;
    twitterTagsForCurrentProject = @"";
    
   

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate addCenterButtonFromcontroller:self];
    
    //Set Sync Animation
    [self setupSyncWaveAnimation];
    //Set signal revi
    [self setupSignalListener];
    [self setupWebservice];
    
    [self.contentWebView setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.centerButton setSelected:YES];
    
    self.reloadWebView = NO;
    [self.tweetButton setHidden:TRUE];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.syncWaveImageView startAnimating];
}

-(void) viewDidDisappear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.centerButton setSelected:NO];
  
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


#pragma mark - Configurations


-(void) setupSyncWaveAnimation
{
    NSMutableArray *SyncAnimationImages = [[NSMutableArray alloc] init];
    for (int i=1; i <=12; i++)
    {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"SyncWave%02d",i]];
        [SyncAnimationImages addObject:img];
    }
    
    [self.syncWaveImageView setAnimationImages:SyncAnimationImages];
    
    [self.syncWaveImageView setAnimationDuration:1];
}

-(void) setupSignalListener
{
    NSLog(@"startListener");
    FilmSync *filmSync = [FilmSync sharedFilmSyncManager];
    [filmSync setDelegate:self];
    [filmSync startListener];
}

-(void) setupWebservice
{
    FilmSyncWebService *filmSyncAPI = [FilmSyncWebService sharedInstance];
    [filmSyncAPI setConnectionURL:kFilmSyncAPIBaseUrl];
    [filmSyncAPI setAPISecret:kFilmSyncAPISecret];
}


#pragma mark - View initialisation
-(void)clearCardView
{
    [self.filmTitleLabel setText:@""];
    [self.cardDescTextView setText:@""];
    [self.statusLabel setText:@""];
    
    [self.tweetButton setHidden:TRUE];
    [self.contentWebView setHidden:YES];
    [self.filmTitleLabel setHidden:YES];
    
    [self.syncStatusLabel setText:@""];
    
    [self.syncWaveImageView setHidden:NO];
    [self.syncStatusLabel setHidden:NO];
    [self.syncWaveImageView startAnimating];
}

#pragma mark - Content load methods

- (IBAction)getCardButtonPressed:(id)sender
{
    NSLog(@"get Card :%@",self.cardIDTextView.text);
    [self newMarkerReceived:self.cardIDTextView.text];
}

//New marker received
-(void)newMarkerReceived:(NSString *)marker
{
    NSLog(@"newMarkerReceived");
    [self clearCardView];
    
    [self.syncStatusLabel setText:@"Loading..."];
    
    [self getCardFromServerForCardID:marker];
}

-(void)loadContentInWebView:(Card *)CardItem
{
    NSLog(@"loadContentInWebView : %@",CardItem.content);
    NSURL* nsUrl = [NSURL URLWithString:CardItem.content];
    [self.filmTitleLabel setText:CardItem.title];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:nsUrl];
    
    [self.contentWebView loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{

    NSLog(@"webViewDidFinishLoad with URL  :%@",[[[theWebView request] URL] absoluteString]);
    if (![[theWebView.request.URL absoluteString] isEqualToString:@"about:blank"])
    {
        NSLog(@"stopAnimating");
        [self.syncWaveImageView stopAnimating];
        [self.syncWaveImageView setHidden:YES];
        [self.syncStatusLabel setHidden:YES];
        
        [self.tweetButton setHidden:FALSE];
        [self.contentWebView setHidden:NO];
        [self.filmTitleLabel setHidden:NO];
        
    }
}

#pragma mark - Twitter

- (IBAction)tweetButtonPressed:(id)sender {
    
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *twitterTags = [NSString stringWithFormat:@"%@ %@\n",kFilmSyncTwitterTag,twitterTagsForCurrentProject];
    [tweetSheet setInitialText:twitterTags];
    
    [self presentViewController:tweetSheet animated:YES completion:nil];
    
}

#pragma mark - FilmSync API methods

-(void)getCardFromServerForCardID:(NSString *)cardID
{
    [[FilmSyncWebService sharedInstance] serverAPI_getCard:cardID usingAsync:NO andCompletionHandler:^(NSDictionary *cardDict)
    {
        if (cardDict)
        {
            if ([[cardDict objectForKey:@"empty"] isEqualToString:@"no"])
            {
                [self newCardReceivedFromServer:cardDict];
            }
            else if ([[cardDict objectForKey:@"empty"] isEqualToString:@"yes"])
            {
                UIAlertView *noContentAlert = [[UIAlertView alloc] initWithTitle:@"Content not available" message:@"This content is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [noContentAlert show];
                
                [self deleteCardWithID:cardID];
            }
            else
            {
                NSLog(@"Card Data Erorr");
            }
        }
        else
        {
            NSLog(@"Card Fetch Error from server");
            UIAlertView *noContentAlert = [[UIAlertView alloc] initWithTitle:@"Card Fetch Error" message:@"Invalid sessionID/APISecret" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [noContentAlert show];
            
        }
        [self.syncStatusLabel setText:@""];
    }];
    /*
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {

                                      
                                      //NSString *titleStr = [[jsonDict objectForKey:@"project"] objectForKey:@"title"];
                                      //[self.filmTitleLabel setText:titleStr];
                                      //_markerDataArray = [jsonDict objectForKey:@"cards"];
                                      //NSLog(@"markerDataArray :%@",self.markerDataArray);
                                      
                                      if (error == nil)
                                      {
                                          NSError *parseError = nil;
                                          NSDictionary *jsonDict = [NSJSONSerialization
                                                                    JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableLeaves
                                                                    error:&parseError];
                                          NSLog(@"jsonDict :%@",jsonDict);
                                          
                                          if (parseError == nil)
                                          {
                                              [self newCardReceivedFromServer:jsonDict];
                                          }
                                      }
                                      else
                                      {
                                          NSLog(@"getAllCardsForProjectFromServer - No Data Or Error Received");
                                      }
                                      
                                      
                                      NSLog(@"error :%@",error);
                                  }];
    
    [task resume];*/
}
-(void) newCardReceivedFromServer:(NSDictionary *)CardDict
{
    NSLog(@"newCardReceivedFromServer");
    Card *receivedCard = [self getExistingCardWithID:[CardDict objectForKey:@"card_id"]];
    if (receivedCard == nil)
    {
        receivedCard = [self newCard:CardDict];
    }

    NSString *projectID = [CardDict objectForKey:@"project_id"];
    twitterTagsForCurrentProject = [CardDict objectForKey:@"twittersearch"];
    Project *projectToBeSaved = [self getExistingProjectWithID:projectID];
    if (projectToBeSaved == nil)
    {
        projectToBeSaved = [[CoreData sharedManager] newEntityForName:@"Project"];
        projectToBeSaved.projectID = projectID;
        projectToBeSaved.twitterSearch = twitterTagsForCurrentProject;
    }
    receivedCard.project = projectToBeSaved;
    
    
    [self loadContentInWebView:receivedCard];
    
    [self saveCardsInDB];
    [self getAllCardsForProjectFromServer:projectID];
}

-(void) newCardReceivedFromLocal:(Card *)Crd
{
    NSLog(@"newCardReceivedFromLocal : %@",Crd.project.projectID);
    [self loadContentInWebView:Crd];
    
    twitterTagsForCurrentProject = Crd.project.twitterSearch;
    NSString *projectID = Crd.project.projectID;
    [self getAllCardsForProjectFromServer:projectID];
}

-(void)getAllCardsForProjectFromServer:(NSString *)projectID
{
    NSLog(@"getAllCardsForProjectFromServer : %@",projectID);
    
    
    [[FilmSyncWebService sharedInstance] serverAPI_getAllCardsForProject:projectID usingAsync:NO andCompletionHandler:^(NSDictionary *cardsDict)
     {
         if (cardsDict)
         {
             
             if ([[cardsDict objectForKey:@"empty"] isEqualToString:@"no"])
             {
                 [self newCardsForProjectReceivedFromServer:cardsDict];
             }
             else if ([[cardsDict objectForKey:@"empty"] isEqualToString:@"yes"])
             {
                 [self deleteProjectWithID:projectID];
             }
             else
             {
                 NSLog(@"Cards Data Erorr");
             }
             
         }
         else
         {
             NSLog(@"Card Fetch Error from server");
         }
     }];
}


-(void) newCardsForProjectReceivedFromServer:(NSDictionary *)Project_AllCardsDict
{
    NSLog(@"newCardsForProjectReceivedFromServer");
    NSDictionary *ProjectDict = [Project_AllCardsDict objectForKey:@"project"];
    Project *newProject = [self newProject:ProjectDict];
    
    NSArray *AllCardsDict = [Project_AllCardsDict objectForKey:@"cards"];
    for (int i=0; i < [AllCardsDict count]; i++)
    {
        NSDictionary *cardDict = [AllCardsDict objectAtIndex:i];
        Card *newCard = [self newCard:cardDict];
        newCard.project = newProject;
    }
    
    [self saveCardsInDB];
}

#pragma mark - CoreData Database methods

-(Project *)newProject:(NSDictionary *)ProjectDict
{
    NSLog(@"newProject");
    NSString *prj_id = [ProjectDict objectForKey:@"project_id"];
    Project *projectToBeSaved = [self getExistingProjectWithID:prj_id];
    if (projectToBeSaved == nil) {
        projectToBeSaved = [[CoreData sharedManager] newEntityForName:@"Project"];
        projectToBeSaved.projectID = prj_id;
    }
    projectToBeSaved.title = [ProjectDict objectForKey:@"title"];
    projectToBeSaved.desc = [ProjectDict objectForKey:@"description"];
    projectToBeSaved.twitterSearch = [ProjectDict objectForKey:@"twittersearch"];
    
    return projectToBeSaved;
}

-(Card *)newCard:(NSDictionary *)cardDict
{
    NSLog(@"newCard");
    NSString *crd_id = [cardDict objectForKey:@"card_id"];
    Card *cardToBeSaved = [self getExistingCardWithID:crd_id];
    if (cardToBeSaved == nil) {
        cardToBeSaved = [[CoreData sharedManager] newEntityForName:@"Card"];
        cardToBeSaved.cardID = crd_id;
    }
    cardToBeSaved.content = [cardDict objectForKey:@"content"];
    cardToBeSaved.title = [cardDict objectForKey:@"title"];
    
    return cardToBeSaved;
}


- (Project *)getExistingProjectWithID:(NSString *)projectID
{
    NSLog(@"getExistingProjectWithID");
    Project *prj = nil;
    NSArray *result = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Project"];
    result = [[CoreData sharedManager] executeCoreDataFetchRequest:fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"projectID = %@",projectID];
    NSArray *filteredArray = [result filteredArrayUsingPredicate:predicate];
    if ([filteredArray count] > 0)
    {
        prj = [filteredArray objectAtIndex:0];
    }
    return prj;
}

- (Card *)getExistingCardWithID:(NSString *)cardID
{
    NSLog(@"getExistingCardWithID");
    Card *crd = nil;
    NSArray *result = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Card"];
    result = [[CoreData sharedManager] executeCoreDataFetchRequest:fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cardID = %@",cardID];
    NSArray *filteredArray = [result filteredArrayUsingPredicate:predicate];
    if ([filteredArray count] > 0)
    {
        crd = [filteredArray objectAtIndex:0];
    }
    
    return crd;
}

-(BOOL) deleteCardWithID:(NSString *)cardID
{
    Card *cardToDelete = [self getExistingCardWithID:cardID];
    if (cardToDelete)
    {
        NSString *projectID = cardToDelete.project.projectID;
        [[CoreData sharedManager] deleteItem:cardToDelete];
        [self getAllCardsForProjectFromServer:projectID];
        return TRUE;
    }
    
    return FALSE;
}

-(BOOL) deleteProjectWithID:(NSString *)projectID
{
    Project *projectToDelete = [self getExistingProjectWithID:projectID];
    if (projectToDelete)
    {
        [[CoreData sharedManager] deleteItem:projectToDelete];
        return TRUE;
    }
    
    return FALSE;
}


/*
 Purpose : commit Entities to database
 */
- (void)saveCardsInDB
{
    [[CoreData sharedManager] saveEntity];
}

#pragma mark - FilmSync Delegate methods

//Dispatched when app is ready to find source audio
-(void) listeningForSource
{
    NSLog(@"listeningForSource ");
    [self.statusLabel setText:@"Listening For Source"];
    
}

//Dispatched once when a signal from an external source is detected for a specific sourceID. Will not be dispatched again till source is lost.
-(void) sourceDetected
{
    NSLog(@"sourceDetected ");
    [self.statusLabel setText:@"Source Detected"];
    [self.syncStatusLabel setText:@"Listening..."];
}

//Dispatched once when no signal detected in timeOut duration.
-(void) sourceLost
{
    NSLog(@"sourceLost ");
    [self.statusLabel setText:@"Source Lost"];
    [self.syncStatusLabel setText:@""];
}

//Dispatched when a proper signal is detected. Sends currentCard id.
-(void) markerDetected:(NSString *)currentCardID
{
    [self newMarkerReceived:currentCardID];
    NSLog(@"markerDetected - currentCardID :%@",currentCardID);
    [self.statusLabel setText:[NSString stringWithFormat:@"Marker Detected :%@",currentCardID]];
}


@end
