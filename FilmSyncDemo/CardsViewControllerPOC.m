//
//  CardsViewControllerPOC.m
//  FilmSyncDemo
//
//  Created by Abdusha on 10/13/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "CardsViewControllerPOC.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "Project.h"
#import "Card.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface CardsViewControllerPOC ()
{
    NSString *twitterTagsForCurrentProject;
}

@end

@implementation CardsViewControllerPOC

@synthesize markerDataArray = _markerDataArray;

// *************** Singleton *********************

static CardsViewControllerPOC *sharedInstance = nil;

#pragma mark -
#pragma mark Singleton Methods
+ (CardsViewControllerPOC *)sharedInstance
{
    if (sharedInstance == nil)
    {
        //sharedInstance = [[CardsViewControllerPOC alloc] init];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedInstance = self;
    
    //self.title = @"Film Home";
    //NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    //NSLog(@"defaults :%@",[defaults stringForKey:@"projectCode"]);
    
    _currentCard = nil;
    twitterTagsForCurrentProject = @"";
    
    NSMutableArray *SyncAnimationImages = [[NSMutableArray alloc] init];
    for (int i=1; i <=12; i++)
    {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"SyncWave%02d",i]];
        [SyncAnimationImages addObject:img];
    }
    
    [self.syncWaveImageView setAnimationImages:SyncAnimationImages];
    
    [self.syncWaveImageView setAnimationDuration:1];
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate addCenterButtonFromcontroller:self];
    
    NSLog(@"startListener");
    FilmSync *filmSync = [FilmSync sharedFilmSyncManager];
    [filmSync setDelegate:self];
    [filmSync startListener];
    
    [self.contentWebView setDelegate:self];
    
    
}
/*
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(CenterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBarController.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBarController.tabBar.center;
    else
    {
        CGPoint center = self.tabBarController.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.tabBarController.view addSubview:button];
}

-(void) CenterButtonPressed :(UIButton *)btn
{
    [btn setHighlighted:!btn.isHighlighted];
    
    NSLog(@"btn.isHighlighted : %d",btn.isHighlighted);
    
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.centerButton setSelected:YES];
    
    self.reloadWebView = NO;
    [self.tweetButton setHidden:TRUE];
    //[self webViewDidFinishLoad:self.contentWebView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [self.syncWaveImageView startAnimating];
    //[self.syncStatusLabel setText:@"Listening..."];
    //Fetch from loacal
    //[self getMarkerDict];
    
    //Fetch from Server
    //[self getAllCardsFromServer];
    
    //moving to viewDidLoad
    /*
    NSLog(@"startListener");
    FilmSync *filmSync = [FilmSync sharedFilmSyncManager];
    [filmSync setDelegate:self];
    [filmSync startListener];*/
    
    
    //NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    //[defaults setObject:@"134" forKey:@"projectCode"];
    //[defaults synchronize];
    
    //[self.contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.10.2.132/filmsync/api/preview/46"]]];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.centerButton setSelected:NO];
    
    /* removed
    NSLog(@"stopListener");
    FilmSync *filmSync = [FilmSync sharedFilmSyncManager];
    [filmSync setDelegate:nil];
    [filmSync stopListener];*/
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

-(void)clearCardView
{
    [self.filmTitleLabel setText:@""];
    [self.cardDescTextView setText:@""];
    [self.statusLabel setText:@""];
    //[self.contentWebView ];
    [self.tweetButton setHidden:TRUE];
    [self.contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [self.syncStatusLabel setText:@""];
    
    [self.syncWaveImageView setHidden:NO];
    [self.syncStatusLabel setHidden:NO];
    [self.syncWaveImageView startAnimating];
}

- (IBAction)getCardButtonPressed:(id)sender
{
    NSLog(@"get Card :%@",self.cardIDTextView.text);
    [self newMarkerReceived:self.cardIDTextView.text];
}

- (IBAction)tweetButtonPressed:(id)sender {
    
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *twitterTags = [NSString stringWithFormat:@"@FilmSyncApp %@\n",twitterTagsForCurrentProject];
    [tweetSheet setInitialText:twitterTags];
    
    [self presentViewController:tweetSheet animated:YES completion:nil];
    
}

//New marker received
-(void)newMarkerReceived:(NSString *)marker
{
    NSLog(@"newMarkerReceived");
    [self clearCardView];

    [self.syncStatusLabel setText:@"Waiting..."];
    //[self.contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];

    
    Card *currentCard = [self getExistingCardWithID:marker];
    if (currentCard != nil)
    {
        [self newCardReceivedFromLocal:currentCard];
    }
    else
    {
         [self getCardFromServerForCardID:marker];
    }
   
    /*
    NSDictionary *markerDict = [self getDataForMarker:marker];
    //NSLog(@"markerDict :%@",markerDict);
    
    //local
    //[self.cardImageView setImage:[UIImage imageNamed:[markerDict objectForKey:@"content"]]];
    //[self.cardDescTextView setText:[markerDict objectForKey:@"title"]];
    
    //Server
    [self.contentWebView setContentMode:UIViewContentModeRedraw];
    //[self.contentWebView setScalesPageToFit:YES];
    NSString* url = [markerDict objectForKey:@"content"];
    //NSString* url = @"http://10.10.2.31/filmsync/projects/preview/000000000084";
    NSURL* nsUrl = [NSURL URLWithString:url];
    //NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:300];
    //[self.contentWebView loadRequest:request];
    
    [self.filmTitleLabel setText:[markerDict objectForKey:@"title"]];
    //NSString *urlAddress = @"http://dl.dropbox.com/u/50941418/2-build.html";
    //NSURL *url = [NSURL URLWithString:urlAddress];
    self.reloadWebView = YES;
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:nsUrl];
    
    [self.contentWebView loadRequest:requestObj];
    //self.contentWebView.delegate = self;*/
}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    NSLog(@"webViewDidFinishLoad");
    
    /*
    if (self.reloadWebView)
    {
        CGSize contentSize = theWebView.scrollView.contentSize;
        CGSize viewSize = self.view.bounds.size;
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *width = [f numberFromString:[self.contentWebView stringByEvaluatingJavaScriptFromString:@"getContentWidth()"]];
        NSNumber *height = [f numberFromString:[self.contentWebView stringByEvaluatingJavaScriptFromString:@"getContentHeight()"]];
        NSLog(@"webViewDidFinishLoad - contentSize - H:%f W:%f",contentSize.height,contentSize.width);
        NSLog(@"webViewDidFinishLoad - viewSize - H:%f W:%f",viewSize.height,viewSize.width);
        NSLog(@"webViewDidFinishLoad - js - H:%@ W:%@",height,width);
        
        float rw = viewSize.width / contentSize.width;
        
        theWebView.scrollView.minimumZoomScale = rw;
        theWebView.scrollView.maximumZoomScale = rw;
        theWebView.scrollView.zoomScale = rw;
        
        //[self.contentWebView setBounds:CGRectMake(10, 50, 450, 320)];
        //[self.contentWebView.scrollView setContentSize:CGSizeMake(450, 320)];
        //[self.contentWebView setBounds:CGRectMake(0, 0, 450, 320)];
        //[self.contentWebView loadRequest:theWebView.request];
        //[self.contentWebView reloadInputViews];
        self.reloadWebView = NO;
    }
    */
    
    NSLog(@"webViewDidFinishLoad with URL  :%@",[[[theWebView request] URL] absoluteString]);
    if (![[theWebView.request.URL absoluteString] isEqualToString:@"about:blank"])
    {
        NSLog(@"stopAnimating");
        [self.syncWaveImageView stopAnimating];
        [self.syncWaveImageView setHidden:YES];
        [self.syncStatusLabel setHidden:YES];
        
        [self.tweetButton setHidden:FALSE];
    }
    
    
    
}
/*
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *width = [f numberFromString:[self.contentWebView stringByEvaluatingJavaScriptFromString:@"getContentWidth()"]];
    NSNumber *height = [f numberFromString:[self.contentWebView stringByEvaluatingJavaScriptFromString:@"getContentHeight()"]];
    
    self.contentWebView.frame = CGRectMake(BORDER_WIDTH, BORDER_WIDTH, _frameWidth, _frameHeight);
    self.contentWebView.bounds = CGRectMake(0, 0, _frameWidth, _frameHeight);
}*/

//get data for the received marker
-(NSDictionary *)getDataForMarker:(NSString *)marker
{
    NSLog(@"getDataForMarker");
    NSDictionary *dict = nil;
    for (NSDictionary *tempDict in self.markerDataArray)
    {
        if ([marker isEqualToString:[tempDict objectForKey:@"card_id"]])
        {
            dict = tempDict;
            break;
        }
    }
    
    return dict;
}

-(void)getMarkerDict
{
    NSLog(@"getMarkerDict");
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Cards" ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    //NSLog(@"json :%@",json);
    
    if (_markerDataArray != nil)
    {
        _markerDataArray= nil;
    }
    
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    NSString *titleStr = [[jsonDict objectForKey:@"project"] objectForKey:@"title"];
    [self.filmTitleLabel setText:titleStr];
    _markerDataArray = [jsonDict objectForKey:@"cards"];
    //NSLog(@"markerDataArray :%@",self.markerDataArray);
    
    
}

-(void)getCardFromServerForCardID:(NSString *)cardID
{
    NSLog(@"getCardFromServerForCardID");
    
    NSString *URLStr = [NSString stringWithFormat:@"http://filmsync.fingent.net/api/getacard/%@",cardID];
    NSURL *URL = [NSURL URLWithString:URLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // Send a synchronous request
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        // Parse data here
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
    Card *receivedCard = [self newCard:CardDict];
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
    //NSDictionary *cardDict = [NSDictionary dictionaryWithObjectsAndKeys:Crd.cardID,@"card_id",Crd.title,@"title",Crd.content,@"content",Crd.project.projectID,@"project_id",Crd.project.twitterSearch,@"twittersearch", nil];
    [self loadContentInWebView:Crd];
    
    NSString *projectID = Crd.project.projectID;
    [self getAllCardsForProjectFromServer:projectID];
}

-(void)getAllCardsForProjectFromServer:(NSString *)projectID
{
    NSLog(@"getAllCardsForProjectFromServer : %@",projectID);
    
    NSString *URLStr = [NSString stringWithFormat:@"http://filmsync.fingent.net/api/getcardsforproject/%@",projectID];
    NSURL *URL = [NSURL URLWithString:URLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      
                                      NSDictionary *jsonDict = [NSJSONSerialization
                                                                JSONObjectWithData:data
                                                                options:NSJSONReadingMutableLeaves
                                                                error:&error];
                                      
                                      NSLog(@"jsonDict :%@",jsonDict);
                                      //NSString *titleStr = [[jsonDict objectForKey:@"project"] objectForKey:@"title"];
                                      //[self.filmTitleLabel setText:titleStr];
                                      //_markerDataArray = [jsonDict objectForKey:@"cards"];
                                      //NSLog(@"markerDataArray :%@",self.markerDataArray);
                                      if (!error && jsonDict)
                                      {
                                          [self newCardsForProjectReceivedFromServer:jsonDict];
                                      }
                                      else
                                      {
                                          NSLog(@"getAllCardsForProjectFromServer - No Data Or Error Received");
                                      }
                                      
                                      NSLog(@"error :%@",error);
                                  }];
    
    [task resume];
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
/*
-(void)loadContentInWebView:(NSDictionary *)CardDict
{
    NSLog(@"loadContentInWebView");
    NSString *urlStr = [CardDict objectForKey:@"content"];
    NSURL* nsUrl = [NSURL URLWithString:urlStr];
    [self.filmTitleLabel setText:[CardDict objectForKey:@"title"]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:nsUrl];
    
    [self.contentWebView loadRequest:requestObj];
}*/
-(void)loadContentInWebView:(Card *)CardItem
{
    NSLog(@"loadContentInWebView");
    NSURL* nsUrl = [NSURL URLWithString:CardItem.content];
    [self.filmTitleLabel setText:CardItem.title];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:nsUrl];
    
    [self.contentWebView loadRequest:requestObj];
    
    
}

-(void)getAllCardsFromServer
{
    NSLog(@"getAllCardsFromServer");
    //NSURL *URL = [NSURL URLWithString:@"http://10.10.2.90/filmsync/getAllCards.json"];
    //NSURL *URL = [NSURL URLWithString:@"http://10.10.2.31/filmsync/api/getallcards"];
    NSURL *URL = [NSURL URLWithString:@"http://filmsync.fingent.net/api/getallcards"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      
                                      NSDictionary *jsonDict = [NSJSONSerialization
                                                                JSONObjectWithData:data
                                                                options:NSJSONReadingMutableLeaves
                                                                error:&error];
                                      
                                      NSLog(@"jsonDict :%@",jsonDict);
                                      //NSString *titleStr = [[jsonDict objectForKey:@"project"] objectForKey:@"title"];
                                      //[self.filmTitleLabel setText:titleStr];
                                      _markerDataArray = [jsonDict objectForKey:@"cards"];
                                      //NSLog(@"markerDataArray :%@",self.markerDataArray);
                                      
                                      NSLog(@"error :%@",error);
                                  }];
    
    [task resume];
  
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
    //NSLog(@"filteredArray :%@",filteredArray);
    
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
    //NSLog(@"filteredArray :%@",filteredArray);
    
    if ([filteredArray count] > 0)
    {
        crd = [filteredArray objectAtIndex:0];
    }
    
    return crd;
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



/*
 Purpose : commit Entities to database
 */
- (void)saveCardsInDB
{
    NSLog(@"saveCardsInDB");
    [[CoreData sharedManager] saveEntity];
}

/*
 Purpose : update and reload the log list table view
 
-(void) reloadDataFromDB
{
    //load data
    _commentsArray = nil;
    _commentsArray = [self getEntitiesFromDatabaseWithName:@"Comments"];
    //update table
    [self.commentsTable reloadData];
    
}*/

@end
