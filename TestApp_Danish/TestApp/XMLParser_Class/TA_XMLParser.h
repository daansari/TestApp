//
//  TA_XMLParser.h
//  TestApp
//
//  Created by Danish Ahmed Ansari on 21/10/13.
//  Copyright (c) 2013 Danish Ahmed Ansari. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kRefreshSongsListTableViewNotificationName;
extern NSString *kShowHideProgress;

@interface TA_XMLParser : NSOperation

@property (copy, readonly) NSData *songsData;

- (id)initWithData:(NSData *)parseData andCount:(NSInteger)totalCount;

@end
