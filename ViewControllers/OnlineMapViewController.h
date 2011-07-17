//
//  OnlineMapViewController.h
//  Sample
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

@class MRMapView;
@class Map;
@interface OnlineMapViewController : UIViewController {
  @private
	MRMapView *mapView;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)addMap;
- (void)addTile:(int)zoom atTileX:(int)x atTileY:(int)y Map:(Map*)newMap;

@end
