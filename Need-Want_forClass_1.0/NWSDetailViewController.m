//
//  NWSDetailViewController.m
//  Need-Want_forClass_1.0
//
//  Created by Louis Tur on 3/20/14.
//  Copyright (c) 2014 Louis Tur. All rights reserved.
//

#import "NWSDetailViewController.h"

@interface NWSDetailViewController ()

@end

@implementation NWSDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter * fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"dd/MM/yyyy"];
    
    self.dateText.text = [fm stringFromDate:self.managedObject.date];
    
    UIPickerView * prioPick = [[UIPickerView alloc] init];
    [prioPick setDelegate:self];
    [prioPick setDataSource:self];
    
    [self.priorityText setInputView:prioPick];
    
    //not fully implemented yet
    UIDatePicker * changeDate = [[UIDatePicker alloc] init];
    [changeDate setDatePickerMode:UIDatePickerModeDate];
    [changeDate setMinimumDate:[NSDate date]];
    //[changeDate setDate:[NSDate date]];
    
    [self.dateText setInputView:changeDate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    
    self.managedObject.title = self.titleText.text;
    self.managedObject.notes = self.notesText.text;
    
#warning this date needs adjusting... not correctly being saved
    NSDateFormatter * fm = [[NSDateFormatter alloc] init];
    self.managedObject.date = [fm dateFromString:self.dateText.text];
    
    [self.delegate didSave];
    
}

- (IBAction)cancel:(id)sender {
    
    [self.delegate didCancel:self.managedObject];
    
}

#pragma mark - Picker View Protocols

//quick test of UIPicker view as an input source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row == 0 ) {
        self.managedObject.category = @"Need";
        self.priorityText.text = @"Need";
    }
    else{
        self.managedObject.category = @"Want";
        self.priorityText.text = @"Want";
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (row == 0) {
        return @"Need";
    }
    else{
        return @"Want";
    }
    
}


- (IBAction)priorityButton:(id)sender {
}
@end
