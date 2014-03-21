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
@property (strong, nonatomic) NSSet * categories;

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

-(NSSet *)categories{
    if (!_categories) {
        _categories = [NSSet set];
    }
    return _categories;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSNumber
    /*NSNumber * setUpSections = [NSNumber numberWithUnsignedInt:2];
    totalSections = [setUpSections unsignedIntegerValue];*/
    
    //this is Settings bundle requirement
    [self checkSettings];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSettings)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [self.containerView setBackgroundColor:[UIColor tickleMeBlue]];
    [self.needButton setTitleColor:[UIColor tickleMePink] forState:UIControlStateNormal];
    
    /*
    //this is the Plist
    NSString * path = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    NSDictionary * testList = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray * allkeys = [testList allKeys];
    
    [self.needList addObjectsFromArray:[testList objectForKey:allkeys[0]]];
    [self.wantList addObjectsFromArray:[testList objectForKey:allkeys[1]]];*/
    /*
    Task * task = (Task *)[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    task.title = @"A Go to Space Cat, Priority 1, Want";
    task.category = @"Want";
    task.priority = @3;
    task.notes = @"Whole milk, skim milk is just water pretending to be milk";
    
    NSError * error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Issue with saving: %@", error);
    }*/
    
    NSError * err = nil;
    if (![self.fetchedResultsController performFetch:&err]) {
        NSLog(@"Issue with fetch: %@", err);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetch Controller

-(NSFetchedResultsController *)fetchedResultsController{
    
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor * sortBy = [NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES];
    NSSortDescriptor * thenBy = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortBy, thenBy]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"category" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

/***************************************************
 
 
 UI Elements: Buttons/Switches
 ***************************************************/

#pragma mark - Button Methods

- (IBAction)mode:(UISwitch *)sender {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (sender.on) {
        self.need = TRUE;
        [self.needButton setTitle:@"Need" forState:UIControlStateNormal];
    }
    else{
        self.need = FALSE;
        [self.needButton setTitle:@"Want" forState:UIControlStateNormal];
    }
    
    [defaults setBool:sender.on forKey:@"enabled_preference"];
    [defaults synchronize];
    
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


/***************************************************
 
 
 Configuring Table
 
 
 ***************************************************/
#pragma mark - UITableView Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Task * currentTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = currentTask.title;
    
    if ([currentTask.category isEqualToString:@"Need"])
        cell.textLabel.textColor = [UIColor tickleMePink];
    
    if ([currentTask.category isEqualToString:@"Want"]){
        cell.textLabel.textColor = [UIColor tickleMeBlue];
    }

    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //I only make this call once to retrieve SectionInfo to demonstrate its use
    id<NSFetchedResultsSectionInfo> sec = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    return [sec numberOfObjects];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.fetchedResultsController sections] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSLog(@"in titles");
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];

}

/***************************************************
 
 
 
 Table Updating
 
 
 ***************************************************/
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id tempStorage;//placeholder object
    
    //get the object at the selected index and section, removes it from it's corresponding array and moves it into another array. in this case either needs -> wants, or vice verse
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

    //need to create an index set for this to work, define it as a range from 0 to 1
    NSIndexSet * sectionSets = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, totalSections) ];
    
        //obviously, [tableview reloadData] works as well, but where's the fun in that?
    [tableView reloadSections:sectionSets withRowAnimation:UITableViewRowAnimationAutomatic];//fade animation
    
}*/

/***************************************************
 
 
 
    Table Editing
 
 
 ***************************************************/

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return TRUE;
}
/*
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

}*/

- (IBAction)editTasks:(UIBarButtonItem *)sender {
    
    if ([self.taskTable isEditing]) {
        [self.taskTable setEditing:FALSE animated:TRUE];
    }else{
        [self.taskTable setEditing:TRUE animated:TRUE];
    }
}

/***************************************************
 
 
 
Alert View
 
 
 ***************************************************/


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"Warning is displayed");
    //future use here
    
}

/***************************************************
 
 
 
 UISwitch State Checks
 
 
 ***************************************************/

-(void) checkSettings{
    self.need = [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_preference"];
    
    self.taskMode.on = self.need;
    
    if (self.need) {
        [self.needButton setTitle:@"Need" forState:UIControlStateNormal];
    }else{
        [self.needButton setTitle:@"Want" forState:UIControlStateNormal];
    }
    
}

/***************************************************
 
 
 Future Method -- Not yet implemented
 
 
 ***************************************************/

- (void) addNewCategory: (NSString *) category{
    
    self.categories = [NSSet setWithObject:category];
    NSLog(@"Category successfully added");
    totalSections++;
    
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"addTask"]) {
        NWSDetailViewController * dvc = [segue destinationViewController];
        
        [dvc setDelegate:self];
    }
    
}

#pragma mark - Delegate View Methods

-(void)didSave{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) didCancel:(id)object{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSFetchResultsController Delegates

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.taskTable beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.taskTable endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"Insert Detected");
            [self.taskTable insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.taskTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:{
            NSLog(@"Update Detected");
            
            Task * changedTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
            
            UITableViewCell *cell = [self.taskTable cellForRowAtIndexPath:indexPath];
            
            cell.textLabel.text = changedTask.title;
            
        }
            break;
            
        case NSFetchedResultsChangeMove:
            
            NSLog(@"Move Detected");
            [self.taskTable deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationFade];
            [self.taskTable insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
    }
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    
    switch (type) {
            
        case NSFetchedResultsChangeInsert:
            
            [self.taskTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeDelete:
            
            [self.taskTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
    }
}

@end
