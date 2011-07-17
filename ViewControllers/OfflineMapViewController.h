//
//  OfflineMapViewController.h
//  Sample
//
//  Created by Grégoire Aubin on 17/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Map, MRMapView;

@interface OfflineMapViewController : UIViewController{
    Map *map;
    MRMapView *mapView;
}

@property (nonatomic, retain) Map *map;
@property (nonatomic, retain) MRMapView *mapView;

@end