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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    
    [self.delegate didSave];
    
}

- (IBAction)cancel:(id)sender {
    
    [self.delegate didCancel:self.managedObject];
    
}
@end
