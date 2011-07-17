//
//  Map.h
//  Sample
//
//  Created by Grégoire Aubin on 17/07/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tile;

@interface Map : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * centerLng;
@property (nonatomic, retain) NSNumber * centerLat;
@property (nonatomic, retain) NSNumber * zoomMax;
@property (nonatomic, retain) NSNumber * zoomMin;
@property (nonatomic, retain) NSSet *tiles;
@end

@interface Map (CoreDataGeneratedAccessors)

- (void)addTilesObject:(Tile *)value;
- (void)removeTilesObject:(Tile *)value;
- (void)addTiles:(NSSet *)values;
- (void)removeTiles:(NSSet *)values;

@end
