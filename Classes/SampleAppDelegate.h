//
//  MapViewAppDelegate.h
//  Sample
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

@class OnlineMapViewController, SavedMapsListViewController;

@interface SampleAppDelegate : NSObject < UIApplicationDelegate > {
  @private
    UIWindow *window;
    UITabBarController *tabBarController;
    OnlineMapViewController *onlineMapViewController;
    SavedMapsListViewController *savedMapsListViewController;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;


@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;


@end
