// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Song.h instead.

#import <CoreData/CoreData.h>


extern const struct SongAttributes {
	__unsafe_unretained NSString *img_url_170;
	__unsafe_unretained NSString *img_url_60;
	__unsafe_unretained NSString *song_id;
	__unsafe_unretained NSString *song_url;
	__unsafe_unretained NSString *title;
} SongAttributes;

extern const struct SongRelationships {
} SongRelationships;

extern const struct SongFetchedProperties {
} SongFetchedProperties;








@interface SongID : NSManagedObjectID {}
@end

@interface _Song : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SongID*)objectID;





@property (nonatomic, strong) NSString* img_url_170;



//- (BOOL)validateImg_url_170:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* img_url_60;



//- (BOOL)validateImg_url_60:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* song_id;



@property int16_t song_idValue;
- (int16_t)song_idValue;
- (void)setSong_idValue:(int16_t)value_;

//- (BOOL)validateSong_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* song_url;



//- (BOOL)validateSong_url:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






@end

@interface _Song (CoreDataGeneratedAccessors)

@end

@interface _Song (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveImg_url_170;
- (void)setPrimitiveImg_url_170:(NSString*)value;




- (NSString*)primitiveImg_url_60;
- (void)setPrimitiveImg_url_60:(NSString*)value;




- (NSNumber*)primitiveSong_id;
- (void)setPrimitiveSong_id:(NSNumber*)value;

- (int16_t)primitiveSong_idValue;
- (void)setPrimitiveSong_idValue:(int16_t)value_;




- (NSString*)primitiveSong_url;
- (void)setPrimitiveSong_url:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
