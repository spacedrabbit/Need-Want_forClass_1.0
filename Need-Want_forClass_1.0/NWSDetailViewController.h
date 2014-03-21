//
//  NWSDetailViewController.h
//  Need-Want_forClass_1.0
//
//  Created by Louis Tur on 3/20/14.
//  Copyright (c) 2014 Louis Tur. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NWSDetailViewControllerDelegate

-(void) didSave;
-(void) didCancel: (id) object;
#warning need to replace this with NSManagedObject later
@end

@interface NWSDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *dateText;
@property (weak, nonatomic) IBOutlet UITextView *notesText;

@property (strong, nonatomic) id<NWSDetailViewControllerDelegate> delegate;

@property (strong, nonatomic) id managedObject;
#warning need to replace this with NSManagedObject later

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
