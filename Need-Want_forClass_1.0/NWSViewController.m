//
//  NWSViewController.m
//  Need-Want_forClass_1.0
//
//  Created by Louis Tur on 3/5/14.
//  Copyright (c) 2014 Louis Tur. All rights reserved.
//

#import "NWSViewController.h"
#import "UIColor+NWSColorizeCustom.h"

@interface NWSViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) NSMutableArray * needList;
@property (strong, nonatomic) NSMutableArray * wantList;

@property (weak, nonatomic) IBOutlet UITableView *taskTable;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *needButton;

@property (weak, nonatomic) IBOutlet UITextField *taskField;

@property (weak, nonatomic) IBOutlet UISwitch *taskMode;
@property (nonatomic) BOOL need;


@property (strong, nonatomic) UIColor * pink;
@property (strong, nonatomic) UIColor * blue;

@end

@implementation NWSViewController
{
    NSUInteger totalSections;
}

-(NSMutableArray *)needList{
    if (!_needList) {
        _needList = [NSMutableArray array];
    }
    return _needList;
}

-(NSMutableArray *)wantList{
    if (!_wantList) {
        _wantList  = [NSMutableArray array];
    }
    return _wantList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    totalSections = 2;
    
    //this is bundle
    self.need = TRUE;
    
    //instance properties not currently in use
    self.pink = [UIColor tickleMePink];//category of UIColor
    self.blue = [UIColor tickleMeBlue];//category of UIColor
    
    
    [self.containerView setBackgroundColor:[UIColor tickleMeBlue]];
    [self.needButton setTitleColor:[UIColor tickleMePink] forState:UIControlStateNormal];
    
    //this is the Plist
    NSString * path = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    NSDictionary * testList = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray * allkeys = [testList allKeys];
    
    [self.needList addObjectsFromArray:[testList objectForKey:allkeys[0]]];
    [self.wantList addObjectsFromArray:[testList objectForKey:allkeys[1]]];
    
}
- (IBAction)mode:(UISwitch *)sender {
    
    if (sender.on) {
        self.need = TRUE;
        [self.needButton setTitle:@"Need" forState:UIControlStateNormal];
    }
    else{
        self.need = FALSE;
        [self.needButton setTitle:@"Want" forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)needButton:(UIButton *)sender {
    
    
    //check to see if something was inputted
    if ([self.taskField.text length] > 0 ){
        //adds task to array
        if (self.need) {
            [self.needList addObject:self.taskField.text];
        }else{
            [self.wantList addObject:self.taskField.text];
        }
    }
    //clears the text field
    self.taskField.text = @"";
    
    //reloads the data and animates
    NSIndexSet * sectionSets = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, totalSections) ];
    
    [self.taskTable reloadSections:sectionSets withRowAnimation:UITableViewRowAnimationAutomatic];

    //dismiss keyboard
    [self.view endEditing:TRUE];
}
/*
- (IBAction)wantButton:(UIButton *)sender {
    
    //check to see if something was inputted
    if ([self.taskField.text length] > 0 ){
        //adds task to array
        [self.wantList addObject:self.taskField.text];
    }
    //clears the text field
    self.taskField.text = @"";
    
    //reloads the data in the 1st section
    [self.taskTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    
    //dismiss keyboard
    [self.view endEditing:TRUE];
}*/



/***************************************************
 
 
 Configuring Table
 
 
 ***************************************************/


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = self.needList[indexPath.row];
        cell.textLabel.textColor = [UIColor tickleMePink];
    }
    else
    {
        cell.textLabel.text = self.wantList[indexPath.row];
        cell.textLabel.textColor = [UIColor tickleMeBlue];
    }
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0){
        return [self.needList count];
    }
    else{
        return [self.wantList count];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return totalSections;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section ==0){
        return @"Needs";
    }else{
        return @"Wants";
    }
}

/***************************************************
 
 
 
 Table Updating
 
 
 ***************************************************/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id tempStorage;//placeholder object
    
    //get the object at the selected index and section, removes it from it's corresponding array and moves it into another array. in this case either tasks > completed, or vice verse
    if(indexPath.section == 0){
        tempStorage = [self.needList objectAtIndex:indexPath.row];
        [self.needList removeObjectAtIndex:indexPath.row];
        [self.wantList addObject:tempStorage];
    }
    else {
        tempStorage = [self.wantList objectAtIndex:indexPath.row];
        [self.wantList removeObjectAtIndex:indexPath.row];
        [self.needList addObject:tempStorage];
    }
    
    //reloads table data to reflect array changes
    //[tableView reloadData];
    
    //need to create an index set for this to work, define it as a range from 0 to 1, ideally I need a count for total number of sections in the app to make this less static
    NSIndexSet * sectionSets = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, totalSections) ];
    
    [tableView reloadSections:sectionSets withRowAnimation:UITableViewRowAnimationAutomatic];//fade animation
    
}

/***************************************************
 
 
 
    Table Editing
 
 
 ***************************************************/

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return TRUE;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        UIAlertView * warning = [[UIAlertView alloc] initWithTitle:@"Task Deletion" message:@"You deleted a task" delegate:self cancelButtonTitle:@"Thanks" otherButtonTitles: nil];
        
        [warning show];

        if (indexPath.section == 0) {
            [self.needList removeObjectAtIndex:indexPath.row];
        }
        else{
            [self.wantList removeObjectAtIndex:indexPath.row];
        }
    }
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (IBAction)editTasks:(UIBarButtonItem *)sender {
    
    if ([self.taskTable isEditing]) {
        [self.taskTable setEditing:FALSE animated:TRUE];
    }else{
        [self.taskTable setEditing:TRUE animated:TRUE];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"Warning is displayed");
    
}

@end
