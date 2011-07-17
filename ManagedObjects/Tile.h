//
//  Tile.h
//  Sample
//
//  Created by Grégoire Aubin on 17/07/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Map;

@interface Tile : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * z;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) id imgData;
@property (nonatomic, retain) Map *map;

@end
