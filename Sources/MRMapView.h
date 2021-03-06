//
//  MRMapView.h
//  MapKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

#import "MRMapTypes.h"

typedef enum {
    iDCMapViewModeOnline,
    iDCMapViewModeOffline,
} iDCMapViewMode;

@class MRMapBaseView, Map;
@protocol MRTileProvider, MRProjection;

/*
  NOTE: MRMapView sets itself as the delegate of its UIScrollView superclass
  Don't change it!
  
  The QuartzCore framework must also be linked against in order to use MRMapView
*/

@interface MRMapView : UIScrollView < UIScrollViewDelegate > {
  @private
    Map *map;
	MRMapBaseView *_baseView;
	iDCMapViewMode mapMode;
	id < MRTileProvider > _tileProvider;
	id < MRProjection > _mapProjection;
}

/*
  If you don't use the - initWithFrame:tileProvider: initializer, the
  tile provider will be nil. It MUST be set in order to display any tiles
*/
@property (nonatomic, retain) id < MRTileProvider > tileProvider;
@property (nonatomic, retain) Map *map;
// The default projection is MRMercatorProjection
@property (nonatomic, retain) id < MRProjection > mapProjection;

@property (nonatomic, assign) MRMapCoordinate center; // animated
@property (nonatomic, assign) NSUInteger zoomLevel;   // animated


// tileProvider must not be nil
- (id)initWithFrame:(CGRect)frame tileProvider:(id < MRTileProvider >)tileProvider;
- (id)initWithFrame:(CGRect)frame mode:(iDCMapViewMode)mode;
- (void)setCenter:(MRMapCoordinate)coord animated:(BOOL)anim;
- (void)setZoomLevel:(NSUInteger)zoom animated:(BOOL)anim;

@end
