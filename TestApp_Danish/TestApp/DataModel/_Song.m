// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Song.m instead.

#import "_Song.h"

const struct SongAttributes SongAttributes = {
	.img_url_170 = @"img_url_170",
	.img_url_60 = @"img_url_60",
	.song_id = @"song_id",
	.song_url = @"song_url",
	.title = @"title",
};

const struct SongRelationships SongRelationships = {
};

const struct SongFetchedProperties SongFetchedProperties = {
};

@implementation SongID
@end

@implementation _Song

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Song";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Song" inManagedObjectContext:moc_];
}

- (SongID*)objectID {
	return (SongID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"song_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"song_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic img_url_170;






@dynamic img_url_60;






@dynamic song_id;



- (int16_t)song_idValue {
	NSNumber *result = [self song_id];
	return [result shortValue];
}

- (void)setSong_idValue:(int16_t)value_ {
	[self setSong_id:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSong_idValue {
	NSNumber *result = [self primitiveSong_id];
	return [result shortValue];
}

- (void)setPrimitiveSong_idValue:(int16_t)value_ {
	[self setPrimitiveSong_id:[NSNumber numberWithShort:value_]];
}





@dynamic song_url;






@dynamic title;











@end
