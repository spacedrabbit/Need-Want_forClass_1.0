//
//  NWSViewController.h
//  Need-Want_forClass_1.0
//
//  Created by Louis Tur on 3/5/14.
//  Copyright (c) 2014 Louis Tur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWSDetailViewController.h"
#import "Task.h"

@interface NWSViewController : UIViewController <NWSDetailViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController * fetchedResultsController;

@end
