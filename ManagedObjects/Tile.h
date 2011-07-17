//
//  Tile.h
//  Sample
//
//  Created by Gene Ehrbar on 7/17/11.
//  Copyright (c) 2011 ISITE Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Map;

@interface Tile : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSNumber * z;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSData * imgData;
@property (nonatomic, retain) NSSet* maps;

@end
