//
//  Map.h
//  Sample
//
//  Created by Gene Ehrbar on 7/17/11.
//  Copyright (c) 2011 ISITE Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tile;

@interface Map : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * Size;
@property (nonatomic, retain) NSNumber * Zoom;
@property (nonatomic, retain) NSNumber * CenterLong;
@property (nonatomic, retain) NSDecimalNumber * longDelta;
@property (nonatomic, retain) NSDecimalNumber * latDelta;
@property (nonatomic, retain) NSString * Provider;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSNumber * CenterLat;
@property (nonatomic, retain) NSSet* tiles;

- (void)addTilesObject:(Tile *)value;

@end
