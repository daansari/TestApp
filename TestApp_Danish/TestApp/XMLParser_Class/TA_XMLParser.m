//
//  TA_XMLParser.m
//  TestApp
//
//  Created by Danish Ahmed Ansari on 21/10/13.
//  Copyright (c) 2013 Danish Ahmed Ansari. All rights reserved.
//

#import "TA_XMLParser.h"
#import "Song.h"
#import "TA_AppDelegate.h"

NSString *kRefreshSongsListTableViewNotificationName = @"RefreshSongsListTableView";
NSString *kShowHideProgress = @"showHideProgress";

@interface TA_XMLParser () <NSXMLParserDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableString *element;
@property (nonatomic) BOOL accumulatingParsedCharacterData;
@property (nonatomic) BOOL enteredEntryElementForSongIdParent;
@property (nonatomic) BOOL enteredEntryElementForSongTitle;
@property (nonatomic) BOOL enteredEntryElementForSongURL;
@property (nonatomic) BOOL coverImgElement;
@property (nonatomic) BOOL albumArtworkElement;
@property (nonatomic, strong) Song *current_song_obj;
@property (nonatomic, strong) NSNumber *current_song_id;
@property (nonatomic, strong) NSMutableDictionary *song_dict;
@property (nonatomic) NSInteger totalNumberOfLines;
@property (nonatomic) CGFloat currentProgressValue;
@property (nonatomic) NSInteger currentLineNumber;

@end

@implementation TA_XMLParser

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (id)initWithData:(NSData *)parseData andCount:(NSInteger)totalCount{
    self = [super init];
    
    if (self) {
        id delegate = (TA_AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        _songsData = [parseData copy];
        _element = [[NSMutableString alloc] init];
        _enteredEntryElementForSongIdParent = NO;
        _enteredEntryElementForSongTitle = NO;
        _enteredEntryElementForSongURL = NO;
        _coverImgElement = NO;
        _albumArtworkElement = NO;
        _totalNumberOfLines = totalCount;
        _currentLineNumber = 0;
        _currentProgressValue = 0;
    }
    return self;
}

- (void)refreshSongsListTableView {
    assert([NSThread isMainThread]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshSongsListTableViewNotificationName object:self];
}

// The main function for this NSOperation, to start the parsing.
- (void)main {
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:_songsData];
    [parser setDelegate:self];
    [parser parse];
}

static NSString * const kSongElement = @"entry";
static NSString * const kSongTitleElementName = @"title";
static NSString * const kSongUrlLinkElementName = @"link";
static NSString * const kSongUrlLinkRelAttributeName = @"rel";
static NSString * const kSongUrlLinkHrefAttributeName = @"href";
static NSString * const kSongUrlAlternateAttributeName = @"alternate";
static NSString * const kSongIdParentElementName = @"id";
static NSString * const kSongIdAttributeName = @"im:id";
static NSString * const kSongImgElementName = @"im:image";
static NSString * const kSongImgAttributeName = @"height";

#pragma mark - Update progress bar
- (void)updateProgressBar {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:_currentProgressValue], @"progress", [NSNumber numberWithInteger:_currentLineNumber], @"currentLineNumber", [NSNumber numberWithInteger:_totalNumberOfLines], @"totalNumberOfLines", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowHideProgress object:nil userInfo:dict];
}

#pragma mark - NSXMLParser Delegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //NSLog(@"Started Element %@", elementName);
    
    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:NO];
    
    if ([elementName isEqualToString:kSongElement]) {
        Song *song = [Song insertInManagedObjectContext:self.managedObjectContext];
        _current_song_obj = song;
        _song_dict = [[NSMutableDictionary alloc] init];
        
        _enteredEntryElementForSongIdParent = YES;
        _enteredEntryElementForSongTitle = YES;
        _enteredEntryElementForSongURL = YES;
    }
    else if ([elementName isEqualToString:kSongIdParentElementName]) {
        if (_enteredEntryElementForSongIdParent == YES) {
            NSString *song_id = [attributeDict valueForKey:kSongIdAttributeName];
            _current_song_id = [NSNumber numberWithDouble:[song_id doubleValue]];
            
            [_song_dict setObject:[NSNumber numberWithDouble:[song_id doubleValue]] forKey:@"Song_id"];
            
            // The contents are collected in parser:foundCharacters:.
            _accumulatingParsedCharacterData = YES;
            // The mutable string needs to be reset to empty.
            self.element = [[NSMutableString alloc] init];
        }
    }
    else if ([elementName isEqualToString:kSongUrlLinkElementName]) {
        if (_enteredEntryElementForSongURL == YES) {
            NSString *song_url_rel_type = [attributeDict valueForKey:kSongUrlLinkRelAttributeName];
            
            if ([song_url_rel_type isEqualToString:kSongUrlAlternateAttributeName]) {
                NSString *song_url_href = [attributeDict valueForKey:kSongUrlLinkHrefAttributeName];
                [_song_dict setObject:song_url_href forKey:@"Song_url"];
            }
            // The contents are collected in parser:foundCharacters:.
            _accumulatingParsedCharacterData = YES;
            // The mutable string needs to be reset to empty.
            self.element = [[NSMutableString alloc] init];
        }
    }
    else if ([elementName isEqualToString:kSongImgElementName]) {
        
        NSString *height_attribute_str = [attributeDict valueForKey:kSongImgAttributeName];
        
        if ([height_attribute_str isEqualToString:@"60"]) {
            _coverImgElement = YES;
            // The contents are collected in parser:foundCharacters:.
            _accumulatingParsedCharacterData = YES;
            // The mutable string needs to be reset to empty.
            self.element = [[NSMutableString alloc] init];
        }
        
        if ([height_attribute_str isEqualToString:@"170"]) {
            _albumArtworkElement = YES;
            // The contents are collected in parser:foundCharacters:.
            _accumulatingParsedCharacterData = YES;
            // The mutable string needs to be reset to empty.
            self.element = [[NSMutableString alloc] init];
        }
        
    }
    else if ([elementName isEqualToString:kSongTitleElementName]) {
        if (_enteredEntryElementForSongTitle == YES) {
            // The contents are collected in parser:foundCharacters:.
            _accumulatingParsedCharacterData = YES;
            // The mutable string needs to be reset to empty.
            self.element = [[NSMutableString alloc] init];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:kSongElement]) {
        
        if ([Song songWithSongId:_current_song_id usingManagedObjectContext:self.managedObjectContext] == nil) {
            //NSLog(@"ENTERED SONG");
            
            _currentLineNumber = [parser lineNumber];
            _currentProgressValue = (CGFloat)[parser lineNumber] / (CGFloat)_totalNumberOfLines;
            
            [_current_song_obj updateAttributes:_song_dict];
            
            [self performSelectorOnMainThread:@selector(checkNetworkAndSaveData) withObject:Nil waitUntilDone:YES];
        }
        else {
            [self.managedObjectContext deleteObject:_current_song_obj];
        }
        
        _enteredEntryElementForSongIdParent = NO;
        _enteredEntryElementForSongTitle = NO;
        _enteredEntryElementForSongURL = NO;
        
    }
    else if ([elementName isEqualToString:kSongIdParentElementName]) {
        if (_enteredEntryElementForSongIdParent == YES) {
            _enteredEntryElementForSongIdParent = NO;
        }
    }
    else if ([elementName isEqualToString: kSongTitleElementName]) {
        
        if (_enteredEntryElementForSongTitle == YES) {
            NSString *title = _element;
            [_song_dict setObject:title forKey:@"Title"];
            _enteredEntryElementForSongTitle = NO;
        }
    }
    else if ([elementName isEqualToString: kSongUrlLinkElementName]) {
        if (_enteredEntryElementForSongURL == YES) {
            _enteredEntryElementForSongURL = NO;
        }
    }
    else if ([elementName isEqualToString:kSongImgElementName]) {
        
        if (_coverImgElement == YES) {
            NSString *coverImgUrl = _element;
            [_song_dict setObject:coverImgUrl forKey:@"Img_url_60"];
            _coverImgElement = NO;
        }
        
        if (_albumArtworkElement == YES) {
            NSString *albumArtworkUrl = _element;
            [_song_dict setObject:albumArtworkUrl forKey:@"Img_url_170"];
            _albumArtworkElement = NO;
        }
        
    }
    
    _accumulatingParsedCharacterData = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_accumulatingParsedCharacterData) {
        [_element appendString:string];
    }
}

#pragma mark - Save Data to Context
- (void)checkNetworkAndSaveData {
    assert([NSThread isMainThread]);
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    if (netStatus == 0) {
        [self.managedObjectContext deleteObject:_current_song_obj];
    }
    else {
        [self saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshSongsListTableViewNotificationName object:self];
    }
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }
    }
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
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return __fetchedResultsController;
}

@end
