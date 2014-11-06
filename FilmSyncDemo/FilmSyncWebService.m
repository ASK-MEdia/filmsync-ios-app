//
//  FilmSyncWebService.m
//  FilmSync
//
//  Created by Abdusha on 11/5/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#import "FilmSyncWebService.h"


#define kFilmSyncWebServiceBaseURL
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
}
-(void)setConnectionURL:(NSString *)url
{
    //TODO : remove "/" from URL
    baseURL = url;
}
-(NSString *)serverAPI_authenticateUsingAsync:(BOOL)isAsync andCompletionHandler:(void (^)(NSString *status))completionHandler
{
    
    NSDictionary *authDict = [self getSessionIDFromServer:apiSecret];
     
     NSString *authStatus = @"";
     authStatus = [authDict objectForKey:@"status"];
     if ([authStatus isEqualToString:@"active"])
     {
         sessionID = [authDict objectForKey:@"sessionid"];
         NSLog(@"Successful authentication");
     }
     else
     {
         sessionID = nil;
         NSLog(@"Invalid API Secret");
     }
    
    completionHandler(authStatus);
    
    return authStatus;
}

-(void)serverAPI_getCard:(NSString *)cardID usingAsync:(BOOL)isAsync andCompletionHandler:(void (^)(NSDictionary* cardDict))completionHandler
{
    __block NSDictionary *cardDict = [self getCardFromServer:cardID];
    NSString *sessionStatus = [cardDict objectForKey:@"session"];
    if ([sessionStatus isEqualToString:@"active"])
    {
        //sessionID = [jsonDict objectForKey:@"sessionid"];
        NSLog(@"valid session");
        completionHandler(cardDict);
    }
    else
    {
        //NSString *stat =  [self serverAPI_authenticateUsingAsync:NO andCompletionHandler:^(NSString *status){}];
        //sessionID = nil;
        
        NSLog(@"Re-authenticating session..");
        NSString *stat =  [self serverAPI_authenticateUsingAsync:NO andCompletionHandler:^(NSString *status){}];
        if ([stat isEqualToString:@"active"])
        {
            cardDict = [self getCardFromServer:cardID];
            
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
        //NSLog(@"jsonDict :%@",jsonDict);
        
        if (parseError)
        {
            /*authStatus = [jsonDict objectForKey:@"status"];
            if ([authStatus isEqualToString:@"active"])
            {
                sessionID = [jsonDict objectForKey:@"sessionid"];
            }
            else
            {
                sessionID = nil;
                NSLog(@"Invalid API Secret");
            }*/
            
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
        //NSLog(@"jsonDict :%@",jsonDict);
        
        if (parseError == nil)
        {
            //[self newCardReceivedFromServer:jsonDict];
           /* NSString *authStatus = [jsonDict objectForKey:@"session"];
            if ([authStatus isEqualToString:@"active"])
            {
                //sessionID = [jsonDict objectForKey:@"sessionid"];
                
            }
            else
            {
                NSString *stat =  [self serverAPI_authenticateUsingAsync:NO andCompletionHandler:^(NSString *status)
                                   {
                                       
                                   }];
                //sessionID = nil;
            }*/
            
        }
    }
    return jsonDict;
}

/*
-(NSString *)serverAPI_authenticateUsingAsync:(BOOL)isAsync andCompletionHandler:(void (^)(NSString *status))completionHandler
{
    NSString *authStatus = @"";
    
    //http://10.10.2.31/filmsync/api/handshake/1253698547
    //http://10.10.2.31/filmsync/api/getcardsforproject/1/Y8LtyhYFQMpjHPSFi9
    
    NSString *URLStr = [NSString stringWithFormat:@"%@/api/handshake/%@",baseURL,apiSecret];
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
        //NSLog(@"jsonDict :%@",jsonDict);
        
        if (parseError == nil)
        {
            authStatus = [jsonDict objectForKey:@"status"];
            if ([authStatus isEqualToString:@"active"])
            {
                sessionID = [jsonDict objectForKey:@"sessionid"];
            }
            else
            {
                sessionID = nil;
                NSLog(@"Invalid API Secret");
            }
            
        }
    }
    
    
    completionHandler(authStatus);
    return authStatus;
}

*/
/*
-(void)serverAPI_getCard:(NSString *)cardID usingAsync:(BOOL)isAsync andCompletionHandler:(void (^)(NSDictionary* cardDict))completionHandler
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@/api/getacard/%@/%@",baseURL,cardID,sessionID];
    NSURL *URL = [NSURL URLWithString:URLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    if (isAsync)
    {
        //Send Async
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          if (error == nil)
                                          {
                                              NSError *parseError = nil;
                                              NSDictionary *jsonDict = [NSJSONSerialization
                                                                        JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableLeaves
                                                                        error:&parseError];
                                              //NSLog(@"jsonDict :%@",jsonDict);
                                              
                                              if (parseError == nil)
                                              {
                                                  //[self newCardReceivedFromServer:jsonDict];
                                                  completionHandler(jsonDict);
                                              }
                                          }
                                          else
                                          {
                                              NSLog(@"getAllCardsForProjectFromServer - No Data Or Error Received");
                                          }
                                          
                                          
                                          NSLog(@"error :%@",error);
                                      }];
        
        [task resume];
    }
    else
    {
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
            __block NSDictionary *jsonDict = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:NSJSONReadingMutableLeaves
                                      error:&parseError];
            //NSLog(@"jsonDict :%@",jsonDict);
            
            if (parseError == nil)
            {
                //[self newCardReceivedFromServer:jsonDict];
                NSString *authStatus = [jsonDict objectForKey:@"session"];
                if ([authStatus isEqualToString:@"active"])
                {
                    //sessionID = [jsonDict objectForKey:@"sessionid"];
                    completionHandler(jsonDict);
                }
                else
                {
                    NSString *stat =  [self serverAPI_authenticateUsingAsync:NO andCompletionHandler:^(NSString *status)
                                       {
                                           
                                       }];
                    //sessionID = nil;
                }
                
                
            }
        }
    }
}
*/

-(NSString *)checkSessionID
{
    if (sessionID != nil )
    {
        return sessionID;
    }
    else
    {
       NSString *stat =  [self serverAPI_authenticateUsingAsync:NO andCompletionHandler:^(NSString *status){}];
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


#pragma mark -



@end
