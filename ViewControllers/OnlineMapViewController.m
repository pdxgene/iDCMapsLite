//
//  SampleViewController.m
//  Sample
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

#import "OnlineMapViewController.h"
#import "MRMapView.h"
#import "MROSMTileProvider.h"
#import "Map.h"
#import "Tile.h"

#define kMaxZoomLevel 18

@interface OnlineMapViewController ()

- (void)loadState;
- (void)saveState:(id)sender;

@end


@implementation OnlineMapViewController

@synthesize managedObjectContext;


- (void)viewDidLoad {
	[super viewDidLoad];
	
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveMap:)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
    
    mapView = [[MRMapView alloc] initWithFrame:self.view.bounds mode:iDCMapViewModeOnline];
	mapView.tileProvider = [[MROSMTileProvider new] autorelease];
	
	[self loadState];
    [self.view addSubview:mapView];
}

- (void)loadState {
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	[defs registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1]
													   forKey:@"zoom"]];
	
	NSUInteger zoom = [defs integerForKey:@"zoom"];
	[mapView setZoomLevel:zoom animated:NO];
	
	MRMapCoordinate center;
	center.latitude = [defs doubleForKey:@"centerLat"];
	center.longitude = [defs doubleForKey:@"centerLng"];
	
	[mapView setCenter:center animated:NO];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(saveState:)
												 name:UIApplicationWillResignActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(saveState:)
												 name:UIApplicationWillTerminateNotification
											   object:nil];
}

- (void)saveState:(id)sender {
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	[defs setInteger:mapView.zoomLevel forKey:@"zoom"];
	
	MRMapCoordinate center = mapView.center;
	[defs setDouble:center.latitude forKey:@"centerLat"];
	[defs setDouble:center.longitude forKey:@"centerLng"];
	
	[defs synchronize];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

//- (IBAction)locateChicago:(id)sender {
//	mapView.zoomLevel = 10;
//	mapView.center = MRMapCoordinateMake(41.85f, -87.65f);
//}

struct _iDCTileDef {
	int z;
	int x;
    int y;
};
typedef struct _iDCTileDef  iDCTileDef;

- (NSMutableArray *)urlGeneratedForTiles:(iDCTileDef[8])tiles{
    
    NSMutableArray *urls = [[NSMutableArray alloc] init];

    for (int i = 0; i < 8; i ++) {
         int level = tiles[i].z;
        
        while (level < kMaxZoomLevel) {
            
            [urls addObject:[NSString stringWithFormat:@"%d/%d/%d",tiles[i].z,tiles[i].x,tiles[i].y]];
            [urls addObject:[NSString stringWithFormat:@"%d/%d/%d",tiles[i].z,tiles[i].x,tiles[i].y]];
            [urls addObject:[NSString stringWithFormat:@"%d/%d/%d",tiles[i].z,tiles[i].x,tiles[i].y]];
            [urls addObject:[NSString stringWithFormat:@"%d/%d/%d",tiles[i].z,tiles[i].x,tiles[i].y]];
            
            level ++;
        }
        
    }
    
    return [urls autorelease];
}


- (void)saveMap:(id)sender{
    MRMapCoordinate center  = mapView.center;
    float lon = center.longitude;
    float lat = center.latitude;
    
    //create an instance of the Map object in Core Data:
//    [self addMap];
	NSLog(@"add map to list");
    
	/*
	 Create a new instance of the Map entity.
	 */
	Map *newMap = (Map *)[NSEntityDescription insertNewObjectForEntityForName:@"Map" inManagedObjectContext:managedObjectContext];
	
    [newMap setTitle:@"Test map title"];
    // Configure the new event with information from the location.
//    MRMapCoordinate center = mapView.center;
//    [newMap setCenterLat:[NSNumber numberWithDouble:center.latitude]];
    [newMap setCenterLat:[NSNumber numberWithFloat:lat]];
    [newMap setCenterLong:[NSNumber numberWithFloat:lon]];
 //   [newMap setCenterLong:[NSNumber numberWithDouble:center.longitude]];
    [newMap setZoom:[NSNumber numberWithInt:mapView.zoomLevel]];
    NSLog(@"newmap lat: %f, long: %f", [newMap.CenterLat floatValue], [newMap.CenterLong floatValue]);
    
	// If it's not possible to get a location, then start with it blank.
	// Should be the location's timestamp, but this will be constant for simulator.
	// [event setCreationDate:[location timestamp]];
    
	// Commit the change.
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
	
	/*
	 Since this is a new event, and events are displayed with most recent events at the top of the list,
	 add the new event to the beginning of the events array; then redisplay the table view.
	 */
    NSLog(@"added");
    
    int z = mapView.zoomLevel;
    
    int solx = (int)(floor((lon + 180.0) / 360.0 * pow(2.0, z)));
    int soly = (int)(floor((1.0 - log( tan(lat * M_PI/180.0) + 1.0 / cos(lat * M_PI/180.0)) / M_PI) / 2.0 * pow(2.0, z)));
    
    NSLog(@"solx = %d", solx);
    NSLog(@"soly = %d", soly);
    NSLog(@"zoom = %d", z);
    
    //1. Save the tile covering this lat/lng:
    NSLog(@"this tile:");
    [self addTile:z atTileX:solx atTileY:soly Map:newMap];
    
    NSLog(@"Neighbor tiles:");
    //1. Save 8 "neighbor" tiles that surround the tile covering this lat/lng:
    [self addTile:z atTileX:solx+1 atTileY:soly+1 Map:newMap];
    [self addTile:z atTileX:solx+1 atTileY:soly-1 Map:newMap];
    [self addTile:z atTileX:solx atTileY:soly+1 Map:newMap];
    [self addTile:z atTileX:solx+1 atTileY:soly Map:newMap];
    [self addTile:z atTileX:solx-1 atTileY:soly Map:newMap];
    [self addTile:z atTileX:solx atTileY:soly-1 Map:newMap];
    [self addTile:z atTileX:solx-1 atTileY:soly+1 Map:newMap];
    [self addTile:z atTileX:solx-1 atTileY:soly-1 Map:newMap]; 
    
    NSLog(@"zoom in one level:");
    //save the four tiles one level closer (zoom in)
    int zl = z+1;
    //2x,2y
    int solxl = 2*solx;
    int solyl = 2*soly;
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", zl, solxl, solyl);
    //2x+1, 2y
    //2x,2y+1
    //2x+1, 2y+1
    
    
    NSLog(@"zoom out one level:");
    //save four tiles one level further (zoom out)
    int zu = z-1;
    int solxu = solx/2;
    int solyu = soly/2;
    int solx1u = solx/2 + 1;
    int soly1u = soly/2 + 1;
    
    //x/2,y/2
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", zu, solxu, solyu);
    //x/2+1, y/2
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", zu, solx1u, solyu);
    //x/2,y/2+1
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", zu, solxu, soly1u);
    //x/2+1, 2y+1
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", zu, solx1u, soly1u);
    
    
}

/*- (void)saveMap:(id)sender{
    MRMapCoordinate center  = mapView.center;
    float lon = center.longitude;
    float lat = center.latitude;
    
    int z = mapView.zoomLevel;
    
    int solx = (int)(floor((lon + 180.0) / 360.0 * pow(2.0, z)));
    int soly = (int)(floor((1.0 - log( tan(lat * M_PI/180.0) + 1.0 / cos(lat * M_PI/180.0)) / M_PI) / 2.0 * pow(2.0, z)));
    
    NSLog(@"solx = %d", solx);
    NSLog(@"soly = %d", soly);
    NSLog(@"zoom = %d", z);
    
    //Neighbor tiles    
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", z, solx+1, soly+1);
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", z, solx+1, soly-1);
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", z, solx, soly+1);
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", z, solx+1, soly);
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", z, solx, soly);
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", z, solx-1, soly);
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", z, solx, soly-1);
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", z, solx-1, soly+1);
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", z, solx-1, soly-1);
    
    
    //down two levels
    int zl = z+2;
    //4x,4y
    int solxl = 4*solx;
    int solyl = 4*soly;
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", zl, solxl, solyl);
    //2x+1, 2y
    //2x,2y+1
    //2x+1, 2y+1
    
    
    //up one level
    int zu = z-1;
    int solxu = solx/2;
    int solyu = soly/2;
    int solx1u = solx/2 + 1;
    int soly1u = soly/2 + 1;
    
    //x/2,y/2
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", zu, solxu, solyu);
    //x/2+1, y/2
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", zu, solx1u, solyu);
    //x/2,y/2+1
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", zu, solxu, soly1u);
    //x/2+1, 2y+1
    NSLog(@"url: http://c.tile.openstreetmaps.org/%d/%d/%d.png", zu, solx1u, soly1u);
    
    
    //[self addMap];
//    struct tiles iDCTileDef[8];
//    
//    NSMutableArray *arr = [self urlGeneratedForTiles:];
//    
//    for (NSString *str in arr) {
//        NSLog(@"%@", str);
//    }
}
*/

/**
 Add a tile to the list
 */
- (void)addTile:(int)zoom atTileX:(int)x atTileY:(int)y Map:(Map*)newMap{
    NSLog(@"add tile from data:");
    NSLog(@"zoom: %d", zoom);
    NSLog(@"x: %d", x);
    NSLog(@"y: %d", y);
    
    //fetch and save map tile from OSM tile server:
    NSString *urlString = [[[NSString alloc] initWithFormat:@"http://c.tile.openstreetmaps.org/%d/%d/%d.png", zoom, x, y] autorelease];
    NSLog(@"fetch and save: %@", urlString);
    
    NSURL *newTileImageUrl = [NSURL URLWithString:urlString];
    NSData *newTileImageData = [[NSData alloc] initWithContentsOfURL:newTileImageUrl];
    
    
	/*
	 Create a new instance of the Tile entity.
	 */
	Tile *newTile = (Tile *)[NSEntityDescription insertNewObjectForEntityForName:@"Tile" inManagedObjectContext:managedObjectContext];
    [newMap addTilesObject:newTile];
    [newTile setX:[NSNumber numberWithInt:x]];
    [newTile setY:[NSNumber numberWithInt:y]];
    [newTile setZ:[NSNumber numberWithInt:zoom]];
    [newTile setImgData:newTileImageData];
    [newTileImageData release];
    NSLog(@"Tile: x: %d, y: %d, z: %d", [newTile.x intValue], [newTile.y intValue], [newTile.z intValue]);
	// Commit the change.
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
	
	/*
	 Since this is a new event, and events are displayed with most recent events at the top of the list,
	 add the new event to the beginning of the events array; then redisplay the table view.
	 */
    NSLog(@"added");
    
}


/**
 Add a map to the list
 */
- (void)addMap {
    

    
}


- (void)dealloc {
	[mapView release];
	
    [super dealloc];
}

@end
