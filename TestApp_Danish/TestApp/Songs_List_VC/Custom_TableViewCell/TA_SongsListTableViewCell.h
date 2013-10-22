//
//  TA_SongsListTableViewCell.h
//  TestApp
//
//  Created by Danish Ahmed Ansari on 21/10/13.
//  Copyright (c) 2013 Danish Ahmed Ansari. All rights reserved.
//  Email - mail.danishaa@gmail.com

#import <UIKit/UIKit.h>

@class Song;

@interface TA_SongsListTableViewCell : UITableViewCell

- (void)setupCellWithSong:(Song *)song;

@end
