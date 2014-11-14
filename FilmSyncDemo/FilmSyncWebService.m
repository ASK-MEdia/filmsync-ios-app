//
//  FilmSyncWebService.m
//  FilmSync
//
//  Created by Abdusha on 11/5/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "FilmSyncWebService.h"


#define kFilmSyncPrefKeySessionID   @"filmSyncPrefKeySessionID"

// Log include the function name and source code line number in the log statement
#ifdef FSW_DEBUG
    #define FSWDebugLog(fmt, ...) NSLog((@"Func: %s, Line: %d, " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define FSWDebugLog(...)
#endif

@implementation FilmSyncWebService
{
    NSString *apiSecret;
    NSString *sessionID;
    NSString *baseURL;
}



// *************** Singleton *********************

static FilmSyncWebService *sharedInstance = nil;

#pragma mark -
#pragma mark Singleton Methods
+ (FilmSyncWebService *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[FilmSyncWebService alloc] init];
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

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


#pragma mark -
#pragma mark APIs
-(void)setAPISecret:(NSString *)ApiKey
{
    apiSecret = ApiKey;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    sessionID = [prefs stringForKey:kFilmSyncPrefKeySessionID];
    
    
}
-(void)setConnectionURL:(NSString *)url
{
    //Remove white space and "/" from end of URL
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([url hasSuffix:@"/"])
    {
        url = [url substringToIndex:[url length] - 1];
    }
    baseURL = url;
}
-(void)serverAPI_authenticateUsingAsync:(BOOL)isAsync andCompletionHandler:(void (^)(NSString *status))completionHandler
{
    
    NSDictionary *authDict = [self getSessionIDFromServer:apiSecret];
     
     NSString *authStatus = @"";
     authStatus = [authDict objectForKey:@"status"];
     if ([authStatus isEqualToString:@"active"])
     {
         sessionID = [authDict objectForKey:@"sessionid"];
         
         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
         [prefs setObject:sessionID forKey:kFilmSyncPrefKeySessionID];
         [prefs synchronize];
         
         NSLog(@"Successful authentication");
     }
     else
     {
         sessionID = nil;
         NSLog(@"Invalid API Secret");
     }
    
    completionHandler(authStatus);
}

-(void)serverAPI_getCard:(NSString *)cardID usingAsync:(BOOL)isAsync andCompletionHandler:(void (^)(NSDictionary* cardDict))completionHandler
{
    __block NSDictionary *cardDict = [self getCardFromServer:cardID];
    NSString *sessionStatus = [cardDict objectForKey:@"session"];
    if ([sessionStatus isEqualToString:@"active"])
    {
        NSLog(@"valid session");
        completionHandler(cardDict);
    }
    else
    {
        NSLog(@"Re-authenticating session..");
        __block NSString *stat =@"";
        
        [self serverAPI_authenticateUsingAsync:NO andCompletionHandler:^(NSString *status)
        {
            stat = status;
        }];
        if ([stat isEqualToString:@"active"])
        {
            cardDict = [self getCardFromServer:cardID];
            
        }
        else
        {
            NSLog(@"Invalid sessionID and API Secret");
            cardDict = nil;
        }
        completionHandler(cardDict);
    }
}
-(void)serverAPI_getAllCardsForProject:(NSString *)projectID usingAsync:(BOOL)isAsync andCompletionHandler:(void (^)(NSDictionary* cardsDict))completionHandler
{
    __block NSDictionary *cardDict = [self getAllCardsForProject:projectID];
    NSString *sessionStatus = [cardDict objectForKey:@"session"];
    if ([sessionStatus isEqualToString:@"active"])
    {
        NSLog(@"valid session");
        completionHandler(cardDict);
    }
    else
    {
        NSLog(@"Re-authenticating session..");
        __block NSString *stat =@"";
        
        [self serverAPI_authenticateUsingAsync:NO andCompletionHandler:^(NSString *status)
        {
            stat = status;
        }];
        
        if ([stat isEqualToString:@"active"])
        {
            cardDict = [self getAllCardsForProject:projectID];
            
        }
        else
        {
            NSLog(@"returning Invalid sessionID and API Secret");
            cardDict = nil;
        }
        completionHandler(cardDict);
    }
}

-(NSDictionary *)getSessionIDFromServer:(NSString *)authKey
{
    NSString *URLStr = [NSString stringWithFormat:@"%@/api/handshake/%@",baseURL,apiSecret];
    NSURL *URL = [NSURL URLWithString:URLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    // Send a synchronous request
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    NSDictionary *jsonDict = nil;
    if (error == nil)
    {
        // Parse data here
        NSError *parseError = nil;
        jsonDict = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:&parseError];
        if (parseError)
        {
            NSLog(@"Server Authentication :%@",parseError);
        }
    }

    return jsonDict;
}

-(NSDictionary *)getCardFromServer:(NSString *)cardID
{
    NSString *URLStr = [NSString stringWithFormat:@"%@/api/getacard/%@/%@",baseURL,cardID,sessionID];
    NSURL *URL = [NSURL URLWithString:URLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSDictionary *jsonDict = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil)
    {
        // Parse data here
        NSError *parseError = nil;
        jsonDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingMutableLeaves
                                          error:&parseError];
        if (parseError == nil)
        {
            NSLog(@"Server getCardFromServer :%@",parseError);
        }
    }
    return jsonDict;
}

-(NSDictionary *)getAllCardsForProject:(NSString *)projectID
{
    NSString *URLStr = [NSString stringWithFormat:@"%@/api/getcardsforproject/%@/%@",baseURL,projectID,sessionID];
    NSURL *URL = [NSURL URLWithString:URLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSDictionary *jsonDict = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil)
    {
        // Parse data here
        NSError *parseError = nil;
        jsonDict = [NSJSONSerialization
                    JSONObjectWithData:data
                    options:NSJSONReadingMutableLeaves
                    error:&parseError];
        
        if (parseError == nil)
        {
            NSLog(@"Server getAllCardsForProject :%@",parseError);
        }
    }
    return jsonDict;
}

-(NSString *)checkSessionID
{
    if (sessionID != nil )
    {
        return sessionID;
    }
    else
    {
       __block NSString *stat = @"";
        [self serverAPI_authenticateUsingAsync:NO andCompletionHandler:^(NSString *status)
        {
            stat = status;
       }];
        if ([stat isEqualToString:@"invalid"])
        {
            NSLog(@"Auth invalid");
        }
        else
        {
            NSLog(@"Auth valid");
        }
    }
    return sessionID;
}


@end
