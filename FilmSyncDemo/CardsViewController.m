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


@interface CardsViewController ()
{
    NSString *twitterTagsForCurrentProject;
}

@end

@implementation CardsViewController

@synthesize currentCardID = _currentCardID;

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
    
    self.currentCardID = @"";
    twitterTagsForCurrentProject = @"";
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate addCenterButtonFromcontroller:self];
    
    //Set Sync Animation
    [self setupSyncWaveAnimation];
    //Set signal receiver
    [self setupSignalListener];
    //set webservice API
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
    [super viewDidAppear:animated];
    [self.syncWaveImageView startAnimating];
    
    // get card , if a cardID is passed from project list
    if (![self.currentCardID isEqualToString:@""])
    {
        [self newMarkerReceived:self.currentCardID];
    }
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.centerButton setSelected:NO];
    self.currentCardID = @"";
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configurations

// configure Sync Animation
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
    [self.syncWaveImageView startAnimating];
}

// configure marker listener
-(void) setupSignalListener
{
    FSDebugLog(@"startListener");
    FilmSync *filmSync = [FilmSync sharedFilmSyncManager];
    [filmSync setDelegate:self];
    [filmSync startListener];
}

// configure Webservice
-(void) setupWebservice
{
    FilmSync *filmSync = [FilmSync sharedFilmSyncManager];
    [filmSync setConnectionURL:kFilmSyncAPIBaseUrl];
    [filmSync setAPISecret:kFilmSyncAPISecret];
}


#pragma mark - View initialisation
// Clear view
-(void)clearCardView
{
    [self.contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [self.filmTitleLabel setText:@""];
    [self.syncStatusLabel setText:@""];
    
    [self.tweetButton setHidden:TRUE];
    [self.contentWebView setHidden:YES];
    [self.filmTitleLabel setHidden:YES];
    
    [self.syncWaveImageView setHidden:NO];
    [self.syncWaveImageView startAnimating];
}

#pragma mark - Content load methods

//New marker received
-(void)newMarkerReceived:(NSString *)marker
{
    FSDebugLog(@"newMarkerReceived");
    [self clearCardView];
    
    if (marker != nil && ![marker isEqualToString:@""])
    {
        [self.syncStatusLabel setText:@"Loading..."];
        [self getCardFromServerForCardID:marker];
    }
}

// load content in webview
-(void)loadContentInWebView:(Card *)CardItem
{
    FSDebugLog(@"loadContentInWebView : %@",CardItem.content);
    NSURL* nsUrl = [NSURL URLWithString:CardItem.content];
    [self.filmTitleLabel setText:CardItem.title];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:nsUrl];
    
    [self.contentWebView loadRequest:requestObj];
}

// Delegate method for Webview
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    FSDebugLog(@"webViewDidFinishLoad with URL  :%@",[[[theWebView request] URL] absoluteString]);
    if (![[theWebView.request.URL absoluteString] isEqualToString:@"about:blank"])
    {
        [self.syncWaveImageView stopAnimating];
        [self.syncWaveImageView setHidden:YES];
        [self.syncStatusLabel setText:@""];
        
        [self.tweetButton setHidden:FALSE];
        [self.contentWebView setHidden:NO];
        [self.filmTitleLabel setHidden:NO];
        
    }
}

#pragma mark - Twitter
// Tweet button pressed
- (IBAction)tweetButtonPressed:(id)sender {
    
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *twitterTags = [NSString stringWithFormat:@"%@ %@\n",kFilmSyncTwitterTag,twitterTagsForCurrentProject];
    [tweetSheet setInitialText:twitterTags];
    
    [self presentViewController:tweetSheet animated:YES completion:nil];
    
}

#pragma mark - FilmSync API methods
// Call API for get card from the server
-(void)getCardFromServerForCardID:(NSString *)cardID
{
    [[FilmSync sharedFilmSyncManager] serverAPI_getCard:cardID andCompletionHandler:^(NSDictionary *cardDict)
    {
        
        if (cardDict)
        {
            if ([[cardDict objectForKey:@"empty"] isEqualToString:@"no"])
            {// Card with Data
                [self newCardReceivedFromServer:cardDict];
            }
            else if ([[cardDict objectForKey:@"empty"] isEqualToString:@"yes"])
            {// Empty card Data
                UIAlertView *noContentAlert = [[UIAlertView alloc] initWithTitle:@"Content not available" message:@"This content is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [noContentAlert show];
                
                [self deleteCardWithID:cardID];
                [self.syncStatusLabel setText:@""];
            }
            else
            {// Error result
                FSDebugLog(@"Card Data Erorr");
                [self.syncStatusLabel setText:@""];
            }
        }
        else
        {//Invalid API Secret
            FSDebugLog(@"Card Fetch Error from server");
            UIAlertView *noContentAlert = [[UIAlertView alloc] initWithTitle:@"Card Fetch Error" message:@"Invalid sessionID/APISecret" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [noContentAlert show];
            [self.syncStatusLabel setText:@""];
            
        }
    }];
    
}
// Callback of get card recived from server
-(void) newCardReceivedFromServer:(NSDictionary *)CardDict
{
    FSDebugLog(@"newCardReceivedFromServer");
    Card *receivedCard = [self getExistingCardWithID:[CardDict objectForKey:@"card_id"]];
    if (receivedCard == nil)
    {
        // Add new card
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
    
    //load card content
    [self loadContentInWebView:receivedCard];
    //update to database
    [self saveCardsInDB];
    // Get/Update cards from the project of current showing card.
    [self getAllCardsForProjectFromServer:projectID];
}

// load card from local database
-(void) newCardReceivedFromLocal:(Card *)Crd
{
    FSDebugLog(@"newCardReceivedFromLocal : %@",Crd.project.projectID);
    //load card content
    [self loadContentInWebView:Crd];
    
    twitterTagsForCurrentProject = Crd.project.twitterSearch;
    NSString *projectID = Crd.project.projectID;
    // Get/Update cards from the project of current showing card.
    [self getAllCardsForProjectFromServer:projectID];
}

// Call Api for get All cards for project
-(void)getAllCardsForProjectFromServer:(NSString *)projectID
{
    FSDebugLog(@"getAllCardsForProjectFromServer : %@",projectID);
    
    
    [[FilmSync sharedFilmSyncManager] serverAPI_getAllCardsForProject:projectID andCompletionHandler:^(NSDictionary *cardsDict)
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
                 FSDebugLog(@"Cards Data Erorr");
             }
             
         }
         else
         {
             FSDebugLog(@"Card Fetch Error from server");
         }
     }];
}

// Callback of get All cards for project from server
-(void) newCardsForProjectReceivedFromServer:(NSDictionary *)Project_AllCardsDict
{
    FSDebugLog(@"newCardsForProjectReceivedFromServer");
    NSDictionary *ProjectDict = [Project_AllCardsDict objectForKey:@"project"];
    //create new project
    Project *newProject = [self newProject:ProjectDict];
    
    //Add cards to the project
    NSArray *AllCardsDict = [Project_AllCardsDict objectForKey:@"cards"];
    for (int i=0; i < [AllCardsDict count]; i++)
    {
        NSDictionary *cardDict = [AllCardsDict objectAtIndex:i];
        Card *newCard = [self newCard:cardDict];
        newCard.project = newProject;
    }
    //update to database
    [self saveCardsInDB];
}

#pragma mark - CoreData Database methods
// create new Project in coreData Database
-(Project *)newProject:(NSDictionary *)ProjectDict
{
    FSDebugLog(@"newProject");
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
//create new Card in coreData Database
-(Card *)newCard:(NSDictionary *)cardDict
{
    FSDebugLog(@"newCard");
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

// check for existing Project in database
- (Project *)getExistingProjectWithID:(NSString *)projectID
{
    FSDebugLog(@"getExistingProjectWithID");
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

// check for existing Card in database
- (Card *)getExistingCardWithID:(NSString *)cardID
{
    FSDebugLog(@"getExistingCardWithID");
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

// delete Card from database
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

// delete Project from database
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

#pragma mark - FilmSync Delegate methodsA
//App is ready to find source audio
-(void) listeningForSource
{
    FSDebugLog(@"listeningForSource ");
}

//A signal from an external source is detected for a specific sourceID. Will not be dispatched again till source is lost.
-(void) sourceDetected
{
    FSDebugLog(@"sourceDetected ");
    [self clearCardView];
    [self.syncStatusLabel setText:@"Listening..."];
}

//No signal detected in timeOut duration.
-(void) sourceLost
{
    FSDebugLog(@"sourceLost ");
    [self.syncStatusLabel setText:@""];
}

//A proper signal is detected. Sends currentCard id.
-(void) markerDetected:(NSString *)currentCardID
{
    self.currentCardID = currentCardID;
    [self newMarkerReceived:currentCardID];
    FSDebugLog(@"markerDetected - currentCardID :%@",currentCardID);
}


@end
