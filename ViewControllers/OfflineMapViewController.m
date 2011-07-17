//
//  OfflineMapViewController.m
//  Sample
//
//  Created by Grégoire Aubin on 17/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OfflineMapViewController.h"
#import "Map.h"
#import "MRMapView.h"
#import "MROSMTileProvider.h"

@implementation OfflineMapViewController

@synthesize map;
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc{
    [map release];
    [mapView release];
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView = [[MRMapView alloc] initWithFrame:self.view.bounds mode:iDCMapViewModeOffline];
	mapView.tileProvider = [[MROSMTileProvider new] autorelease];
	
    [self.view addSubview:mapView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
