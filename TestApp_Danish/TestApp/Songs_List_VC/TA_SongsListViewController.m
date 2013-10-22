//
//  TA_SongsListViewController.m
//  TestApp
//
//  Created by Danish Ahmed Ansari on 21/10/13.
//  Copyright (c) 2013 Danish Ahmed Ansari. All rights reserved.
//  Email - mail.danishaa@gmail.com

#import "TA_SongsListViewController.h"
#import "TA_SongsListTableViewCell.h"
#import "Song.h"
#import "TA_XMLParser.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "TA_SongDetailViewController.h"

@interface TA_SongsListViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

// queue that manages our NSOperation for parsing earthquake data
@property (nonatomic) NSOperationQueue *parseQueue;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSDictionary *user_info;
@end

@implementation TA_SongsListViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Songs";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    [_hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
    [_hud setLabelText:@"Synchronizing..."];
    [_hud setDetailsLabelText:@" "];
    [_hud setLabelFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    [_hud setDetailsLabelFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    
    [self.view addSubview:_hud];
    [_hud setAlpha:0.0f];
    
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
    [self.tableView registerClass:[TA_SongsListTableViewCell class]forCellReuseIdentifier:@"Song_Cell"];
    
    [self setupNetworkConnectionToParseXML];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableView:)
                                                 name:kRefreshSongsListTableViewNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showHideProgress:)
                                                 name:kShowHideProgress object:nil];
}


#pragma mark - Setup network connection to iTunes XML
- (void)setupNetworkConnectionToParseXML {
    //NSLog(@"ENTERED");
    static NSString *feedURLString = @"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=40/xml";
    
    self.parseQueue = [[NSOperationQueue alloc] init];
    
    NSError *error = nil;
    NSString *xmlFileString = [NSString stringWithContentsOfURL:[NSURL URLWithString:feedURLString]
                                                       encoding:NSUTF8StringEncoding error:&error];
    NSInteger totalLines = [xmlFileString componentsSeparatedByString:@"\n"].count;
    
    
    NSURLRequest *songsURLRequest =
    [NSURLRequest requestWithURL:[NSURL URLWithString:feedURLString]];
    
    [NSURLConnection sendAsynchronousRequest:songsURLRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               
                               if (connectionError != nil) {
                                   // Show alert for connection error
                                   [self handleError:connectionError];
                               }
                               else {
                                   // check for any response errors
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                   
                                   if ((([httpResponse statusCode]/100) == 2) && [[response MIMEType] isEqual:@"application/atom+xml"]) {
                                       
                                       // Create an NSOperation to parse the songs
                                       
                                       TA_XMLParser *parseOperation = [[TA_XMLParser alloc] initWithData:data andCount:totalLines];
                                       [self.parseQueue addOperation:parseOperation];
                                       //NSLog(@"Custom Response - %@", response);
                                       
                                   }
                                   else {
                                       NSString *errorString =
                                       NSLocalizedString(@"HTTP Error", @"Error message displayed when receving a connection error.");
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errorString};
                                       NSError *reportError = [NSError errorWithDomain:@"HTTP"
                                                                                  code:[httpResponse statusCode]
                                                                              userInfo:userInfo];
                                       [self handleError:reportError];
                                   }
                               }
                               
                           }];
    
    // Start the status bar network activity indicator.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.parseQueue = [NSOperationQueue new];
}


#pragma mark - Handle Error
- (void)handleError:(NSError *)error {
    
    NSString *errorMessage = [error localizedDescription];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
    alertView.tag = 1;
    [alertView show];
}

#pragma mark - NSNotificationCenter Selector Methods
- (void)refreshTableView:(NSNotification *)notif {
    [self.tableView reloadData];
}

- (void)showHideProgress:(NSNotification *)notif {
    _user_info = [notif userInfo];
    
    if ([[_user_info valueForKey:@"currentLineNumber"] integerValue] > 0) {
        
        if (_hud.alpha == 0.0f) {
            [_hud show:YES];
        }
        _hud.progress = [[_user_info valueForKey:@"progress"] floatValue];
        _hud.detailsLabelText = [NSString stringWithFormat:@"Line %i of %i", [[_user_info valueForKey:@"currentLineNumber"] integerValue], [[_user_info valueForKey:@"totalNumberOfLines"] integerValue]];
        if ([[_user_info valueForKey:@"progress"] floatValue] > 0.92) {
            [_hud hide:YES];
        }
    }
    else {
        if (_hud.alpha == 1.0f) {
            [_hud hide:TRUE];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self.view window] == nil) {
        
        _hud = nil;
        _user_info = nil;
        _progressView = nil;
        __fetchedResultsController = nil;
        __managedObjectContext = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kRefreshSongsListTableViewNotificationName
                                                  object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kShowHideProgress
                                                  object:nil];
    }
}

#pragma mark - UIAlertview Delegate Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [self setupNetworkConnectionToParseXML];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    //NSLog(@"[sectionInfo numberOfObjects] - %i", [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [(TA_SongsListTableViewCell *)cell setupCellWithSong:song];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Song_Cell";
    TA_SongsListTableViewCell *cell = (TA_SongsListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell..
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    TA_SongDetailViewController *songDetailVC = [[TA_SongDetailViewController alloc] init];
    songDetailVC.song = song;
    
    [self.navigationController pushViewController:songDetailVC animated:YES];
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    [fetchRequest setEntity:[Song entityInManagedObjectContext:self.managedObjectContext]];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return __fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}


@end
