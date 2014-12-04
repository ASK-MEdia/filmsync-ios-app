//
//  Constants.h
//  FilmSyncDemo
//
//  Created by Abdusha on 11/13/14.
//  Copyright (c) 2014 Fingent. All rights reserved.
//

#ifndef FilmSyncDemo_Constants_h
#define FilmSyncDemo_Constants_h




#define kFilmSyncAPIBaseUrl         @"http://filmsync.org"
#define kFilmSyncAPISecret          @"1253698547"
#define kFilmSyncTwitterTag         @"@FilmSyncApp"

// Log include the function name and source code line number in the log statement
#ifdef FS_DEBUG
    #define FSDebugLog(fmt, ...) NSLog((@"Func: %s, Line: %d, " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define FSDebugLog(...)
#endif

#endif
