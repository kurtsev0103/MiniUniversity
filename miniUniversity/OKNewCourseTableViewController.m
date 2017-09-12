//
//  OKNewCourseTableViewController.m
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 29.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKNewCourseTableViewController.h"
#import "OKDataManager.h"
#import "OKStudent+CoreDataProperties.h"
#import "OKNewStudentTableViewController.h"
#import "OKAddStudentsViewController.h"
#import "OKAddTeacherViewController.h"
#import "OKTeacher+CoreDataProperties.h"
#import "OKCourse+CoreDataProperties.h"

@interface OKNewCourseTableViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField* teacherTextField;
@property (nonatomic, strong) UITextField* addStudentsTextField;
@property (nonatomic, strong) UITextField* courseNameTextField;
@property (nonatomic, strong) UITextField* disciplineNameTextField;
@property (nonatomic, strong) NSMutableArray* studentsOnCourse;

@end

@implementation OKNewCourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(actionSave:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    if (self.course) {
        self.navigationItem.title = @"Course:";
        
        NSManagedObjectContext* context = [OKDataManager sharedManager].persistentContainer.viewContext;
        NSFetchRequest* fetchRequest = [NSFetchRequest new];
        NSEntityDescription* descriptionTeacher = [NSEntityDescription entityForName:@"OKTeacher"
                                                              inManagedObjectContext:context];
        [fetchRequest setEntity:descriptionTeacher];
        
        NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
        
        NSPredicate* predicateTeacher = [NSPredicate predicateWithFormat:@"course contains %@", self.course];
        [fetchRequest setPredicate:predicateTeacher];
        
        NSArray* teacher = [NSArray arrayWithArray:[context executeFetchRequest:fetchRequest error:nil]];
        
        self.delegateTeacher = [teacher firstObject];

        NSEntityDescription* description = [NSEntityDescription entityForName:@"OKStudent"
                                                       inManagedObjectContext:context];
        [fetchRequest setEntity:description];
        
        NSSortDescriptor* firstNameDescriptorS = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        NSSortDescriptor* lastNameDescriptorS = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        [fetchRequest setSortDescriptors:@[firstNameDescriptorS, lastNameDescriptorS]];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"course CONTAINS %@", self.course];
        [fetchRequest setPredicate:predicate];
        
        self.delegateArrayStudents = [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:nil]];

    } else {
        self.navigationItem.title = @"Add New Course:";
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.studentsOnCourse = [NSMutableArray arrayWithArray:self.delegateArrayStudents];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setStudent:(OKCourse *)newCourse {
    if (_course != newCourse) {
        _course = newCourse;
    }
}

#pragma mark - Actions

- (void)actionSave:(UIBarButtonItem*)sender {
    
    NSManagedObjectContext* managedObjectContext = [OKDataManager sharedManager].persistentContainer.viewContext;
    
    if (!self.course) {
        
        OKCourse* course = [NSEntityDescription insertNewObjectForEntityForName:@"OKCourse"
                                                         inManagedObjectContext:managedObjectContext];
        
        course.courseName = self.courseNameTextField.text;
        course.disciplineName = self.disciplineNameTextField.text;
        course.teacher = self.delegateTeacher;
        course.student = nil;
        [course addStudent:[NSSet setWithArray:self.delegateArrayStudents]];
        
    } else {
        
        self.course.courseName = self.courseNameTextField.text;
        self.course.disciplineName = self.disciplineNameTextField.text;
        self.course.teacher = self.delegateTeacher;
        self.course.student = nil;
        [self.course addStudent:[NSSet setWithArray:self.delegateArrayStudents]];

    }
    
    [[OKDataManager sharedManager] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Methods

- (UILabel*)createLabelWithCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0 + 20, 0,
                                                               CGRectGetWidth(cell.bounds) / 2,
                                                               CGRectGetHeight(cell.bounds))];
    label.textAlignment = NSTextAlignmentLeft;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |
                                                                    UIViewAutoresizingFlexibleBottomMargin;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        label.text = @"Course name:";
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        label.text = @"Discipline name:";
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        label.text = @"Teacher:";
    }
    
    return label;
}

- (UITextField*)createTextFieldWithCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(cell.bounds) / 2 - 50, 0,
                                                                           CGRectGetWidth(cell.bounds) / 2 + 50,
                                                                           CGRectGetHeight(cell.bounds))];
    
    textField.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
                                                                        UIViewAutoresizingFlexibleBottomMargin;
    
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor blueColor];
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.returnKeyType = UIReturnKeyNext;
    textField.delegate = self;
    
    if (self.course) {
        
        if (indexPath.row == 0) {
            textField.text = self.course.courseName;
            self.courseNameTextField = textField;
        } else if (indexPath.row == 1) {
            textField.text = self.course.disciplineName;
            self.disciplineNameTextField = textField;
            textField.returnKeyType = UIReturnKeyDone;
        } else {
            NSString* str = [NSString stringWithFormat:@"%@ %@", self.delegateTeacher.firstName,
                                                                 self.delegateTeacher.lastName];
            textField.text = str;
            self.teacherTextField = textField;
        }
        
    } else {
        
        if (indexPath.row == 0) {
            
            if (!self.courseNameTextField) {
                textField.placeholder = @"Enter course name";
                self.courseNameTextField = textField;
            } else {
                textField.text = self.courseNameTextField.text;
                self.courseNameTextField = textField;
            }
            
        } else if (indexPath.row == 1) {
            
            if (!self.disciplineNameTextField) {
                textField.placeholder = @"Enter discipline name";
                self.disciplineNameTextField = textField;
                textField.returnKeyType = UIReturnKeyDone;
            } else {
                textField.text = self.disciplineNameTextField.text;
                self.disciplineNameTextField = textField;
                textField.returnKeyType = UIReturnKeyDone;
            }
            
        } else {
            
            if (self.delegateTeacher) {
                
                NSString* str = [NSString stringWithFormat:@"%@ %@", self.delegateTeacher.firstName,
                                 self.delegateTeacher.lastName];
                textField.text = str;
                self.teacherTextField = textField;
                
            } else {
                
                textField.text = @"Select a teacher";
                self.teacherTextField = textField;
            }
            
        }
    }
    
    return textField;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        OKStudent* student = [self.studentsOnCourse objectAtIndex:indexPath.row - 1];
        NSArray* allCourses = [student.course allObjects];
        
        for (int i = 0; i < allCourses.count; i++) {
            if ([student.course containsObject:self.course]) {
                [self.course removeStudentObject:student];
                [self.studentsOnCourse removeObject:student];
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [tableView endUpdates];
            }
        }
        
        [[OKDataManager sharedManager] saveContext];
        
    }
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"About the course:";
    } else if (section == 1) {
        return @"Students on the course:";
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else  {
        return (self.studentsOnCourse.count + 1);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifierFirstSection = @"Cell_First";
    static NSString* identifier = @"Cell";

    if (indexPath.section == 0) {
        
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:identifierFirstSection];

        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UILabel* label = [self createLabelWithCell:cell indexPath:indexPath];
        [cell addSubview:label];
        
        UITextField* textField = [self createTextFieldWithCell:cell indexPath:indexPath];
        
        [cell addSubview:textField];
        
        return cell;

    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                           reuseIdentifier:identifierFirstSection];
            
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0,
                                                                                   CGRectGetWidth(cell.bounds),
                                                                                   CGRectGetHeight(cell.bounds))];
            
            textField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            
            textField.textAlignment = NSTextAlignmentCenter;
            textField.textColor = [UIColor blueColor];
            textField.borderStyle = UITextBorderStyleNone;
            textField.text = @"Add students";
            textField.delegate = self;
            self.addStudentsTextField = textField;
            
            [cell addSubview:textField];
            
            return cell;
            
        } else {
            
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            OKStudent* student = [self.studentsOnCourse objectAtIndex:(indexPath.row - 1)];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
            
            if ([(NSString*)student.gender isEqualToString:@"Male"]) {
                cell.imageView.image = [UIImage imageNamed:@"male_icon.png"];
            } else if ([(NSString*)student.gender isEqualToString:@"Female"]) {
                cell.imageView.image = [UIImage imageNamed:@"female_icon.png"];
            }
            return cell;
        }
    
        return nil;
    }
    
    return nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.addStudentsTextField]) {
        
        OKAddStudentsViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OKAddStudentsViewController"];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        vc.modalPresentationStyle = UIModalPresentationPopover;
        vc.delegate = self;
        vc.allStudentsOnCourse = self.delegateArrayStudents;
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return NO;
        
    } else if ([textField isEqual:self.teacherTextField]) {
        
        OKAddTeacherViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OKAddTeacherViewController"];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        vc.modalPresentationStyle = UIModalPresentationPopover;
        vc.teacher = self.delegateTeacher;
        vc.delegate = self;

        [self presentViewController:nav animated:YES completion:nil];
        
        return NO;
        
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.courseNameTextField]) {
        [self.disciplineNameTextField becomeFirstResponder];
    } else if ([textField isEqual:self.disciplineNameTextField]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    return YES;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    
    if (indexPath.row != 0) {
        OKNewStudentTableViewController *controller = segue.destinationViewController;
        OKStudent* student;
        
        if ([[segue identifier] isEqualToString:@"showDetail"]) {
            student = [self.studentsOnCourse objectAtIndex:indexPath.row - 1];
            [controller setStudent:student];
        }
        
    }
}

@end
