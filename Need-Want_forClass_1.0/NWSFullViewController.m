//
//  NWSFullViewController.m
//  Need-Want_forClass_1.0
//
//  Created by Louis Tur on 3/22/14.
//  Copyright (c) 2014 Louis Tur. All rights reserved.
//

#import "NWSFullViewController.h"

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
    
}

-(void)makeEditable{
    
    for (UITextField * txt in self.theTexts ) {
        [txt setEnabled:![txt isEnabled]];
        //[txt setBorderStyle:UITextBorderStyleBezel];
    }
    
    [self.notesLabel setEditable:![self.notesLabel isEditable]];
}

@end
