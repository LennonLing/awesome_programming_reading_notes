//
//  YDViewController.m
//  CoreDemo
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //Copyright (c) 2013 YourDeveloper. All rights reserved.
//

#import "YDViewController.h"
#import "YDAppDelegate.h"
#import "YDPersonViewController.h"
@interface YDViewController ()<NSFetchedResultsControllerDelegate>

@end

@implementation YDViewController

- (YDAppDelegate *)appDelegate
{
	return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"CoreDemo";
    // Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // Configure the add button.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPerson)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self dummy];
    [self loadPeople];
}
-(void)dummy
{
    for (int i=1;i<10;i++)
        {
        
        Person*  newPerson =[NSEntityDescription
                             insertNewObjectForEntityForName:@"Person"
                             inManagedObjectContext:[self  appDelegate].managedObjectContext];
        newPerson.firstname=[NSString stringWithFormat:@"first %i",i];
        newPerson.lastname=[NSString stringWithFormat:@"last %i",i];
        newPerson.vip = [NSNumber numberWithBool:NO];
        
        }
    NSError *error = nil;
    if (![[self  appDelegate].managedObjectContext save:&error]) {
            //handle your error
    }
}
-(void)loadPeople
{
    if (people)
       people=nil;
    people=[[NSMutableArray alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person"
                                              inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for(int i = 0;i<[fetchedObjects count];i++)
        {
        Person *obj = (Person *)[fetchedObjects objectAtIndex:i];
        [people addObject:obj];
        }
    [self.mTableView reloadData];
}

#pragma delegate is called when the controller content did change
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[self.mTableView reloadData];
}


-(void)addPerson
{
      
   YDPersonViewController* personvc = [[YDPersonViewController alloc] initWithNibName:@"YDPersonViewController" bundle:nil];
   [self.navigationController pushViewController:personvc animated:YES];
}
 #pragma UITableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{     return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [people count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Person* thisPerson = [people objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",thisPerson.firstname,thisPerson.lastname];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         Person* thisPerson = [people objectAtIndex:indexPath.row];
        [[self appDelegate].managedObjectContext deleteObject:thisPerson];
        NSError *error = nil;
        if (![[self  appDelegate].managedObjectContext save:&error]) {
                //handle your error
        }
        [self loadPeople];
    }
}
#pragma edit and undo management
#pragma mark Undo support
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	if (editing) {
		[self setUpUndoManager];
	}
	else {
		[self cleanUpUndoManager];
            // Save the changes.
		NSError *error;
            	if (![[self appDelegate].managedObjectContext save:&error]) {
                // Update to handle the error appropriately.
            	NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
            }
	}
}

- (void)setUpUndoManager {
 	if ([self appDelegate].managedObjectContext.undoManager == nil) {
		self.thisUndoManager = [[NSUndoManager alloc] init];
		[self.thisUndoManager setLevelsOfUndo:3];
        [self appDelegate].managedObjectContext.undoManager = self.thisUndoManager;
	}
	
   	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:self.thisUndoManager];
	[dnc addObserver:self selector:@selector(undoManagerDidRedo:) name:NSUndoManagerDidRedoChangeNotification object:self.thisUndoManager];
 
}


- (void)cleanUpUndoManager {
	[[NSNotificationCenter defaultCenter] removeObserver:self];	
	if ([self appDelegate].managedObjectContext.undoManager == self.thisUndoManager) {
		[self appDelegate].managedObjectContext.undoManager = nil;
		self.thisUndoManager = nil;
	}
    
}

- (void)undoManagerDidUndo:(NSNotification *)notification {
    
    [self.thisUndoManager undo];
    //update the UI like reloading UITableView or setting Edit/Undo/Redo buttons
}


- (void)undoManagerDidRedo:(NSNotification *)notification {
    
    [self.thisUndoManager redo];
     //update the UI like reloading UITableView or setting Edit/Undo/Redo buttons
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
