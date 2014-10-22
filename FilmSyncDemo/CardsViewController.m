//
//  CardsViewController.m
//  FilmSyncDemo
//
//  Created by Abdusha on 9/12/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "CardsViewController.h"
#import "SWRevealViewController.h"

@interface CardsViewController ()

@end

@implementation CardsViewController


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
    
    self.title = @"Film Home";
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    NSLog(@"defaults :%@",[defaults stringForKey:@"projectCode"]);
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.filmTitleLabel setText:@""];
    [self.cardDescTextView setText:@""];
    [self.statusLabel setText:@""];
    
    [self getMarkerDict];
    
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

//New marker received
-(void)newMarkerReceived:(NSString *)marker
{
    NSDictionary *markerDict = [self getDataForMarker:marker];
    //NSLog(@"markerDict :%@",markerDict);
    [self.cardImageView setImage:[UIImage imageNamed:[markerDict objectForKey:@"content"]]];
    [self.cardDescTextView setText:[markerDict objectForKey:@"title"]];
}

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
