//
//  MRTileCache.h
//  MapKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

@class Map;

@interface MRTileCache : NSObject {
  @private
	NSUInteger _maxCacheSize;
	NSString *_cacheDirectory;
	BOOL _flushing;
    Map *map;
}

@property (assign) NSUInteger maxCacheSize; /* in tiles, default=1,000 */
@property (readonly) NSString *cacheDirectory;

- (id)initWithCacheDirectory:(NSString *)aPath;

// thread safe...
- (NSData *)tileAtX:(NSUInteger)x y:(NSUInteger)y zoomLevel:(NSUInteger)zoom;
- (void)setTile:(NSData	*)data x:(NSUInteger)x y:(NSUInteger)y zoomLevel:(NSUInteger)zoom;


// Offline mode
- (NSData *)offlineTileAtX:(NSUInteger)x y:(NSUInteger)y zoomLevel:(NSUInteger)zoom forMap:(Map *)aMap;
// Dispatches a new thread and flushes old caches from the disk
- (void)flushOldCaches;

@end
