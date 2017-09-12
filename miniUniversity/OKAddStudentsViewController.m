//
//  OKAddStudentsViewController.m
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 30.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKAddStudentsViewController.h"
#import "OKDataManager.h"
#import "OKStudent+CoreDataProperties.h"
#import "OKTeacher+CoreDataProperties.h"
#import "OKCourse+CoreDataProperties.h"

@interface OKAddStudentsViewController ()

@property (nonatomic, strong) NSArray* allStudents;

@property (nonatomic, strong) NSMutableArray* studentsForDelete;
@property (nonatomic, strong) NSMutableArray* studentsForAdd;

@end

@implementation OKAddStudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.studentsForDelete = [NSMutableArray new];
    self.studentsForAdd = [NSMutableArray new];
    
    UIBarButtonItem* save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                          target:self
                                                                          action:@selector(actionSave:)];
    self.navigationItem.rightBarButtonItem = save;
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionBack:)];
    self.navigationItem.leftBarButtonItem = back;
    
    NSManagedObjectContext* context = [OKDataManager sharedManager].persistentContainer.viewContext;
    NSFetchRequest* fetchRequest = [NSFetchRequest new];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"OKStudent"
                                                   inManagedObjectContext:context];
    [fetchRequest setEntity:description];

    NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    self.allStudents = [context executeFetchRequest:fetchRequest error:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)actionSave:(UIBarButtonItem*)sender {
    
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.allStudentsOnCourse];

    for (int i = 0; i < self.allStudents.count; i++) {
        
        OKStudent* student = [self.allStudents objectAtIndex:i];
        
        for (OKStudent* studAdd in self.studentsForAdd) {
            if ([student isEqual:studAdd]) {
                [array addObject:student];
            }
        }
        
        for (OKStudent* studDel in self.studentsForDelete) {
            if ([student isEqual:studDel]) {
                [array removeObject:student];
            }
        }

    }
    
    self.delegate.delegateArrayStudents = [array copy];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionBack:(UIBarButtonItem*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allStudents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"Cell";
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    OKStudent* student = [self.allStudents objectAtIndex:indexPath.row];
    NSString* text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.textLabel.text = text;
    
    if ([(NSString*)student.gender isEqualToString:@"Male"]) {
        cell.imageView.image = [UIImage imageNamed:@"male_icon.png"];
    } else if ([(NSString*)student.gender isEqualToString:@"Female"]) {
        cell.imageView.image = [UIImage imageNamed:@"female_icon.png"];
    }
    
    for (int i = 0; i < self.allStudentsOnCourse.count; i++) {
        OKStudent* stud = [self.allStudentsOnCourse objectAtIndex:i];
        
        if ([stud isEqual:student]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OKStudent* student = [self.allStudents objectAtIndex:indexPath.row];

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.studentsForAdd addObject:student];
        [self.studentsForDelete removeObject:student];
        
    } else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.studentsForAdd removeObject:student];
        [self.studentsForDelete addObject:student];

    }
    
}

@end
