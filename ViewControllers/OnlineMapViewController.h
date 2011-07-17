//
//  OnlineMapViewController.h
//  Sample
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

@class MRMapView;

@interface OnlineMapViewController : UIViewController {
  @private
	MRMapView *mapView;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)addMap;

@end
