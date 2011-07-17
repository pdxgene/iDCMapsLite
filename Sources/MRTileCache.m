//
//  MRTileCache.m
//  MapKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

#import "MRTileCache.h"
#import "Tile.h"
#import "Map.h"
#include <sys/stat.h>

@interface MRTileCache ()

- (NSString *)tileKeyForX:(NSUInteger)x y:(NSUInteger)y zoomLevel:(NSUInteger)zoom;
- (NSString *)pathForTileAtX:(NSUInteger)x y:(NSUInteger)y zoomLevel:(NSUInteger)zoom;

- (NSDate *)modificationDateForItemAtPath:(NSString *)aPath;
- (NSArray *)cacheContents;

- (void)flushCachesThread;

@property (readonly) BOOL flushing;

@end


@implementation MRTileCache

@synthesize maxCacheSize = _maxCacheSize;
@synthesize cacheDirectory = _cacheDirectory;
@synthesize flushing = _flushing;

static NSString *const kTileKeyFormat = @"%d_%d_%d.png";

#define kDefaultMaxCacheSize 1000

- (id)initWithCacheDirectory:(NSString *)aPath {
	NSParameterAssert (aPath != nil);
	
	self = [super init];
	if (self) {
		self.maxCacheSize = kDefaultMaxCacheSize;
		_cacheDirectory = [aPath copy];
	}
	return self;
}

- (NSString *)tileKeyForX:(NSUInteger)x y:(NSUInteger)y zoomLevel:(NSUInteger)zoom {
	return [NSString stringWithFormat:kTileKeyFormat, x, y, zoom];
}

- (NSString *)pathForTileAtX:(NSUInteger)x y:(NSUInteger)y zoomLevel:(NSUInteger)zoom {
	NSString *tileKey = [self tileKeyForX:x y:y zoomLevel:zoom];
	
	return [self.cacheDirectory stringByAppendingPathComponent:tileKey];
}

- (NSData *)tileAtX:(NSUInteger)x y:(NSUInteger)y zoomLevel:(NSUInteger)zoom {
	if (self.flushing)
		return nil;
	
	NSFileManager *fm = [[NSFileManager alloc] init];
	
	NSString *path = [self pathForTileAtX:x y:y zoomLevel:zoom];
	NSData *data = [fm contentsAtPath:path];
	
	[fm release];
	
	if (!data)
		return nil;
	
	return data;
}

- (void)setTile:(NSData *)data x:(NSUInteger)x y:(NSUInteger)y zoomLevel:(NSUInteger)zoom {
	if (self.flushing)
		return;
	
	NSString *path = [self pathForTileAtX:x y:y zoomLevel:zoom];
	[data writeToFile:path atomically:YES];
}

- (NSDate *)modificationDateForItemAtPath:(NSString *)aPath {
	struct tm *date;
	struct stat attrib;
	
	stat([aPath fileSystemRepresentation], &attrib);
	date = gmtime(&(attrib.st_mtime));
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setSecond:date->tm_sec];
	[comps setMinute:date->tm_min];
	[comps setHour:date->tm_hour];
	[comps setDay:date->tm_mday];
	[comps setMonth:date->tm_mon + 1];
	[comps setYear:date->tm_year + 1900];
	
	static NSCalendar *cal;
	
	if (!cal)
		cal = [NSCalendar currentCalendar];
	
	NSTimeInterval tz = [[NSTimeZone systemTimeZone] secondsFromGMT];
	
	NSDate *modificationDate = [[cal dateFromComponents:comps] dateByAddingTimeInterval:tz];
	[comps release];
	
	return modificationDate;
}

- (NSArray *)cacheContents {
	NSFileManager *fm = [[NSFileManager alloc] init];
	NSString *cacheDirectory = self.cacheDirectory;
    NSArray *contents = [fm contentsOfDirectoryAtPath:cacheDirectory error:nil];
		
	NSMutableArray *files = [NSMutableArray arrayWithCapacity:[contents count]];
	
	for (NSString *path in contents) {
		NSString *fPath = [cacheDirectory stringByAppendingPathComponent:path];
		NSDate *modificationDate = [self modificationDateForItemAtPath:fPath];
		
		[files addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						  fPath, @"path",
						  modificationDate, @"modificationDate", nil]];
	}
	
	[fm release];
	
	[files sortUsingComparator:^(id path1, id path2) {
		return [[path1 objectForKey:@"modificationDate"] compare:
				[path2 objectForKey:@"modificationDate"]];
	}];
	
	return files;
}

- (void)flushOldCaches {
	if (self.flushing)
		return;
	
	[NSThread detachNewThreadSelector:@selector(flushCachesThread) toTarget:self withObject:nil];
}

- (void)flushCachesThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	_flushing = YES;
	
	NSFileManager *fm = [[NSFileManager alloc] init];
	
	NSArray *contents = [self cacheContents];
	NSUInteger count = [contents count];
	
	if (count >= _maxCacheSize) {
		// free so we have 2/3 of the max size
		for (NSUInteger n = 0; n < (count - (_maxCacheSize * 2 / 3)); n++) {
			NSString *path = [[contents objectAtIndex:n] valueForKey:@"path"];
			[fm removeItemAtPath:path error:nil];
		}
	}
	
	[fm release];
	
	_flushing = NO;
	
	[pool release];
}

- (void)dealloc {
	[_cacheDirectory release];
	[map release];
	[super dealloc];
}


///offline
- (NSData *)offlineTileAtX:(NSUInteger)x y:(NSUInteger)y zoomLevel:(NSUInteger)zoom forMap:(Map *)aMap{
    NSLog(@"get offline tile");
    map = aMap;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tile" inManagedObjectContext:map.managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSLog(@"fetch: x: %d, y: %d, z: %d", x,y,zoom);
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"x=%d AND y=%d AND z=%d",x, y,zoom];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *results =  [[NSMutableArray alloc] initWithArray:[map.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
    [fetchRequest release];
    
    NSData *data = nil;
    if (results && [results count] >0) {
        Tile *tile = (Tile *)[results objectAtIndex:0];
        data = [[NSData alloc] initWithData:tile.imgData];
        NSLog(@"tile in db");
    }
    [results release];
    if (data) {
        return [data autorelease];
    }
	
    else{
        return nil;
    }

}

@end
