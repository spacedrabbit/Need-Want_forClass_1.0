//
//  NWSFullViewController.m
//  Need-Want_forClass_1.0
//
//  Created by Louis Tur on 3/22/14.
//  Copyright (c) 2014 Louis Tur. All rights reserved.
//

#import "NWSFullViewController.h"
#import "NWSAppDelegate.h"

@interface NWSFullViewController ()

@end

@implementation NWSFullViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.taskLabel.text = self.selectedTask.title;
    self.categoryLabel.text = self.selectedTask.category;
    self.notesLabel.text = self.selectedTask.notes;
    
    NSDateFormatter * fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"dd/MM/yyyy"];
    self.dateLabel.text = [fm stringFromDate:self.selectedTask.date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)quickEdit:(UIButton *)sender {
    
    [self makeEditable];
    
    if ( [sender.titleLabel.text isEqualToString:@"quickEdit"]) {
        [self.taskLabel becomeFirstResponder];
        [self.quickEdit setTitle:@"done" forState:UIControlStateNormal];
    }
    else{
        [self.quickEdit setTitle:@"quickEdit" forState:UIControlStateNormal];
    }
    
    [self saveEdits];
    
}

// makes the text fields editable or not
-(void)makeEditable{
    
    for (UITextField * txt in self.theTexts ) {
        [txt setEnabled:![txt isEnabled]];
        
        if ([txt isEnabled]) {
            [txt setBorderStyle:UITextBorderStyleBezel];
        }
        else{
            //I use this as a visual indicator that it can be edited
            [txt setBorderStyle:UITextBorderStyleNone];
        }
        
    }
    
    [self.notesLabel setEditable:![self.notesLabel isEditable]];
}

-(void) saveEdits{
    
    self.selectedTask.title = self.taskLabel.text;
    self.selectedTask.notes = self.notesLabel.text;
    self.selectedTask.category = self.categoryLabel.text;
    
    //made a category to handle my specific formatting
    self.selectedTask.date = [[NSDateFormatter nwsDateForm] dateFromString:self.dateLabel.text];
    
    NWSAppDelegate * myDelegate = [[UIApplication sharedApplication] delegate];
    [myDelegate saveContext];
    
}

@end
