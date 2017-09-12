//
//  OKCourseViewController.m
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 29.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKCourseViewController.h"
#import "OKCourse+CoreDataProperties.h"
#import "OKNewCourseTableViewController.h"
#import "OKCoursesTableViewCell.h"

@interface OKCourseViewController ()

@end

@implementation OKCourseViewController
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
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"OKCourse"
                                                   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:description];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor* nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"courseName" ascending:YES];
    [fetchRequest setSortDescriptors:@[nameDescriptor]];
    
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
        
    OKCourse* course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    OKCoursesTableViewCell* myCell = (OKCoursesTableViewCell*)cell;
    
    myCell.courseNameLabel.text = course.courseName;
    myCell.disciplineNameLabel.text = course.disciplineName;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    OKNewCourseTableViewController *controller = segue.destinationViewController;

    if ([[segue identifier] isEqualToString:@"showDetail"]) {

        OKCourse* course = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [controller setCourse:course];

    }
}

@end
