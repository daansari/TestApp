//
//  TA_SongsListViewController.h
//  TestApp
//
//  Created by Danish Ahmed Ansari on 21/10/13.
//  Copyright (c) 2013 Danish Ahmed Ansari. All rights reserved.
//  Email - mail.danishaa@gmail.com

#import <UIKit/UIKit.h>

@interface TA_SongsListViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
