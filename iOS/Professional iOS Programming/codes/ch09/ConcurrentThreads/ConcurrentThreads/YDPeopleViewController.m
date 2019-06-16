//
//  YDPeopleViewController.m
//  ConcurrentThreads
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDPeopleViewController.h"
#import "YDAppDelegate.h"
#import "People.h"
@interface YDPeopleViewController ()
{
      NSMutableArray* people;
    BOOL processing;
}
- (IBAction)createContacts:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation YDPeopleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"People";
    }
    return self;
}
- (YDAppDelegate *)appDelegate
{
	return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadPeople];
    processing=NO;
}
-(void)loadPeople
{
    if (people)
        people=nil;
    people=[[NSMutableArray alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"People"
                                              inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for(int i = 0;i<[fetchedObjects count];i++)
        {
        People *obj = (People *)[fetchedObjects objectAtIndex:i];
        [people addObject:obj];
        }
    [self.mTableView reloadData];
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
    People* obj = [people objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",obj.name,obj.phone];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createContacts:(UIButton *)sender
{
    //create contact from this background dispatch queue
    if (!processing)
        {
    dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    processing=YES;
    dispatch_async(bgQueue, ^{
        self.bgCTX = [[NSManagedObjectContext alloc]  initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [self.bgCTX setUndoManager:nil];
        [self.bgCTX setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [self.bgCTX setPersistentStoreCoordinator:[[self appDelegate] persistentStoreCoordinator]];
       
        for (int i=0;i<1000;i++)
            {
            People*  newPeople =[NSEntityDescription
                                 insertNewObjectForEntityForName:@"People"
                                 inManagedObjectContext:self.bgCTX];
            newPeople.name= [NSString stringWithFormat:@"name %i",i];
            newPeople.phone= [NSString stringWithFormat:@"phone %i",i];
            }
        NSError *error = nil;
        if (![self.bgCTX save:&error]) {
            //handle your error
            
        }
        //reload people of course on the main queue
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            processing=NO;
        	[self loadPeople];
        });

        
    });
        bgQueue=nil;
        }
}
@end
