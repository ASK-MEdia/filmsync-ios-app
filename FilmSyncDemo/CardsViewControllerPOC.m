//
//  CardsViewControllerPOC.m
//  FilmSyncDemo
//
//  Created by Abdusha on 10/13/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "CardsViewControllerPOC.h"
#import "AppDelegate.h"

@interface CardsViewControllerPOC ()

@end

@implementation CardsViewControllerPOC

@synthesize markerDataArray = _markerDataArray;

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
    
    //self.title = @"Film Home";
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    NSLog(@"defaults :%@",[defaults stringForKey:@"projectCode"]);
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate addCenterButtonFromcontroller:self];
    
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.centerButton setSelected:YES];
    
    self.reloadWebView = NO;
    [super viewWillAppear:animated];
    
    //[self webViewDidFinishLoad:self.contentWebView];
    [self.filmTitleLabel setText:@""];
    [self.cardDescTextView setText:@""];
    [self.statusLabel setText:@""];
    //[self.contentWebView ];
    [self.contentWebView loadHTMLString:@"" baseURL:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    //Fetch from loacal
    //[self getMarkerDict];
    
    //Fetch from Server
    [self getAllCardsFromServer];
    
    NSLog(@"startListener");
    FilmSync *filmSync = [FilmSync sharedFilmSyncManager];
    [filmSync setDelegate:self];
    [filmSync startListener];
    
    
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"134" forKey:@"projectCode"];
    [defaults synchronize];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.centerButton setSelected:NO];
    NSLog(@"stopListener");
    FilmSync *filmSync = [FilmSync sharedFilmSyncManager];
    [filmSync setDelegate:nil];
    [filmSync stopListener];
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


- (IBAction)getCardButtonPressed:(id)sender
{
    NSLog(@"get Card :%@",self.cardIDTextView.text);
    [self newMarkerReceived:self.cardIDTextView.text];
}

//New marker received
-(void)newMarkerReceived:(NSString *)marker
{
    [self.contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];

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
    //self.contentWebView.delegate = self;
}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    NSLog(@"webViewDidFinishLoad");
    
    
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

-(void)getAllCardsFromServer
{
    
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
}

//Dispatched once when no signal detected in timeOut duration.
-(void) sourceLost
{
    NSLog(@"sourceLost ");
    [self.statusLabel setText:@"Source Lost"];
}

//Dispatched when a proper signal is detected. Sends currentCard id.
-(void) markerDetected:(NSString *)currentCardID
{
    [self newMarkerReceived:currentCardID];
    NSLog(@"markerDetected - currentCardID :%@",currentCardID);
    [self.statusLabel setText:[NSString stringWithFormat:@"Marker Detected :%@",currentCardID]];
}

@end
