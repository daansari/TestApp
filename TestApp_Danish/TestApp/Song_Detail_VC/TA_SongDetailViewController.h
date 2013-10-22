//
//  TA_SongDetailViewController.h
//  TestApp
//
//  Created by Danish Ahmed Ansari on 22/10/13.
//  Copyright (c) 2013 Danish Ahmed Ansari. All rights reserved.
//  Email - mail.danishaa@gmail.com

#import <UIKit/UIKit.h>
@class Song;

@interface TA_SongDetailViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) Song *song;

@end
