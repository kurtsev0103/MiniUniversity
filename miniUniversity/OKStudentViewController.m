//
//  OKStudentViewController.m
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 28.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKStudentViewController.h"
#import "OKStudent+CoreDataProperties.h"
#import "OKNewStudentTableViewController.h"
#import "OKStudentsTableViewCell.h"

@interface OKStudentViewController ()

@end

@implementation OKStudentViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [NSFetchRequest new];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"OKStudent"
                                                   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:description];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    OKStudent* student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    OKStudentsTableViewCell* myCell = (OKStudentsTableViewCell*)cell;
    
    myCell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    myCell.mailLabel.text = student.mail;
    
    if ([(NSString*)student.gender isEqualToString:@"Male"]) {
        myCell.genderImageView.image = [UIImage imageNamed:@"male_icon.png"];
    } else if ([(NSString*)student.gender isEqualToString:@"Female"]) {
        myCell.genderImageView.image = [UIImage imageNamed:@"female_icon.png"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    OKNewStudentTableViewController *controller = segue.destinationViewController;

    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        OKStudent* student = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [controller setStudent:student];
        
    } 
}

@end
