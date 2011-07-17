//
//  Map.m
//  Sample
//
//  Created by Gene Ehrbar on 7/17/11.
//  Copyright (c) 2011 ISITE Design. All rights reserved.
//

#import "Map.h"
#import "Tile.h"


@implementation Map
@dynamic Size;
@dynamic Zoom;
@dynamic CenterLong;
@dynamic longDelta;
@dynamic latDelta;
@dynamic Provider;
@dynamic Title;
@dynamic CenterLat;
@dynamic tiles;

- (void)addTilesObject:(Tile *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tiles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"tiles"] addObject:value];
    [self didChangeValueForKey:@"tiles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTilesObject:(Tile *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tiles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"tiles"] removeObject:value];
    [self didChangeValueForKey:@"tiles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTiles:(NSSet *)value {    
    [self willChangeValueForKey:@"tiles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"tiles"] unionSet:value];
    [self didChangeValueForKey:@"tiles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTiles:(NSSet *)value {
    [self willChangeValueForKey:@"tiles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"tiles"] minusSet:value];
    [self didChangeValueForKey:@"tiles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
