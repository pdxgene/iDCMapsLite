//
//  SavedMapsListViewController.h
//  Sample
//
//  Created by Grégoire Aubin on 17/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedMapsListViewController : UITableViewController <NSFetchedResultsControllerDelegate>{
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end