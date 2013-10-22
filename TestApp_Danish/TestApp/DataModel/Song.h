#import "_Song.h"

@interface Song : _Song {}
// Custom logic goes here.

+ (Song *)songWithSongId:(NSNumber *)songId
                   usingManagedObjectContext:(NSManagedObjectContext *)moc;


- (void)updateAttributes:(NSDictionary *)attributes;

@end
