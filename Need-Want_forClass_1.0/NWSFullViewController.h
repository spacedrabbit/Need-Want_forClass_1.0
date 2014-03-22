//
//  NWSFullViewController.h
//  Need-Want_forClass_1.0
//
//  Created by Louis Tur on 3/22/14.
//  Copyright (c) 2014 Louis Tur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "NSDateFormatter+NWForm.h"

@interface NWSFullViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *taskLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesLabel;
@property (weak, nonatomic) IBOutlet UIButton *quickEdit;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *theTexts;


@property (strong, nonatomic) Task * selectedTask;

- (IBAction)quickEdit:(UIButton *)sender;
- (void) makeEditable;

@end
