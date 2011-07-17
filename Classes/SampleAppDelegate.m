//
//	MapViewAppDelegate.m
//	Sample
//
//	Copyright Matt Rajca 2010. All rights reserved.
//

#import "SampleAppDelegate.h"
#import "OnlineMapViewController.h"
#import "SavedMapsListViewController.h"

@implementation SampleAppDelegate

@synthesize window, tabBarController;
@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;
@synthesize managedObjectModel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	tabBarController = [[UITabBarController alloc]init];
    NSManagedObjectContext *context = [self managedObjectContext];
	if (!context) {
		// Handle the error.
	}
    
    onlineMapViewController = [[OnlineMapViewController alloc] init];
    onlineMapViewController.title = @"Online Map";
    onlineMapViewController.managedObjectContext = self.managedObjectContext;
    savedMapsListViewController = [[SavedMapsListViewController alloc] init];
    savedMapsListViewController.title = @"Saved Maps";
    savedMapsListViewController.managedObjectContext = self.managedObjectContext;
    
    UINavigationController *mapNavController = [[[UINavigationController alloc]initWithRootViewController:onlineMapViewController]autorelease];
    UINavigationController *savedMapsNavViewController  = [[[UINavigationController alloc]initWithRootViewController:savedMapsListViewController]autorelease];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:mapNavController, savedMapsNavViewController, nil];
    
    self.window.rootViewController = tabBarController;
    
    [window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
	[onlineMapViewController release];
    [savedMapsListViewController release];
    [tabBarController release];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	[window release];
	[super dealloc];
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    
    
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"SavedMapData.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle the error.
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}



/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle the error.
        } 
    }
}


@end
