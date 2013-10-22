#import "Song.h"


@interface Song ()

// Private interface goes here.

@end


@implementation Song

// Custom logic goes here.

+ (Song *)songWithSongId:(NSNumber *)songId
                   usingManagedObjectContext:(NSManagedObjectContext *)moc {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Song entityName]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"song_id = %@", songId]];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ERROR: %@ %@", [error localizedDescription], [error userInfo]);
        //exit(1);
    }
    
    if ([results count] == 0) {
        return nil;
    }
    
    return [results objectAtIndex:0];
}

- (void)updateAttributes:(NSDictionary *)attributes {
    self.song_id        = [attributes objectForKeyOrNil:@"Song_id"];
    
    self.img_url_60     = [attributes objectForKeyOrNil:@"Img_url_60"];
    
    self.img_url_170    = [attributes objectForKeyOrNil:@"Img_url_170"];
    
    self.title          = [attributes objectForKeyOrNil:@"Title"];
    
    self.song_url       = [attributes objectForKeyOrNil:@"Song_url"];
}

@end
