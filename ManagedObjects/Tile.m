//
//  Tile.m
//  Sample
//
//  Created by Gene Ehrbar on 7/17/11.
//  Copyright (c) 2011 ISITE Design. All rights reserved.
//

#import "Tile.h"
#import "Map.h"


@implementation Tile
@dynamic y;
@dynamic z;
@dynamic x;
@dynamic imgData;
@dynamic maps;

- (void)addMapsObject:(Map *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"maps" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"maps"] addObject:value];
    [self didChangeValueForKey:@"maps" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMapsObject:(Map *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"maps" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"maps"] removeObject:value];
    [self didChangeValueForKey:@"maps" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addMaps:(NSSet *)value {    
    [self willChangeValueForKey:@"maps" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"maps"] unionSet:value];
    [self didChangeValueForKey:@"maps" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeMaps:(NSSet *)value {
    [self willChangeValueForKey:@"maps" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"maps"] minusSet:value];
    [self didChangeValueForKey:@"maps" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
