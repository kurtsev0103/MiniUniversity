//
//  OKTeacherViewController.m
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 29.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKTeacherViewController.h"
#import "OKTeacher+CoreDataProperties.h"
#import "OKTeacherTableViewCell.h"
#import "OKNewTeacherTableViewController.h"

@interface OKTeacherViewController ()

@end

@implementation OKTeacherViewController
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
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"OKTeacher"
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
    
    OKTeacher* teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    OKTeacherTableViewCell* myCell = (OKTeacherTableViewCell*)cell;
    
    myCell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];
    myCell.nameCourse.text = [NSString stringWithFormat:@"Count courses: %ld", (long)teacher.course.count];
    
    if ([(NSString*)teacher.gender isEqualToString:@"Male"]) {
        myCell.genderImageView.image = [UIImage imageNamed:@"teacher_male.png"];
    } else if ([(NSString*)teacher.gender isEqualToString:@"Female"]) {
        myCell.genderImageView.image = [UIImage imageNamed:@"teacher_female.png"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    OKNewTeacherTableViewController *controller = segue.destinationViewController;
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        OKTeacher* teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [controller setTeacher:teacher];
        
    }
}

@end
