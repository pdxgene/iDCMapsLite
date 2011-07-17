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

/**
 Add a map to the list
 */
- (void)addMap {
    
	NSLog(@"add map to list");
    
	/*
	 Create a new instance of the Map entity.
	 */
	Map *newMap = (Map *)[NSEntityDescription insertNewObjectForEntityForName:@"Map" inManagedObjectContext:managedObjectContext];
	
    [newMap setTitle:@"Test map title"];
    // Configure the new event with information from the location.
    MRMapCoordinate center = mapView.center;
    [newMap setCenterLat:[NSNumber numberWithDouble:center.latitude]];
    [newMap setCenterLng:[NSNumber numberWithDouble:center.longitude]];

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
    
}


- (void)dealloc {
	[mapView release];
	
    [super dealloc];
}

@end
