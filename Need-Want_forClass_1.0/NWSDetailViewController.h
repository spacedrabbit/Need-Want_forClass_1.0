//
//  NWSDetailViewController.h
//  Need-Want_forClass_1.0
//
//  Created by Louis Tur on 3/20/14.
//  Copyright (c) 2014 Louis Tur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol NWSDetailViewControllerDelegate

-(void) didSave;
-(void) didCancel: (Task *) object;

@end

@interface NWSDetailViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *dateText;
@property (weak, nonatomic) IBOutlet UITextView *notesText;
@property (weak, nonatomic) IBOutlet UITextField *priorityText;
@property (weak, nonatomic) IBOutlet UIButton *priorityButton;


@property (strong, nonatomic) id<NWSDetailViewControllerDelegate> delegate;

@property (strong, nonatomic) Task * managedObject;

- (IBAction)priorityButton:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
