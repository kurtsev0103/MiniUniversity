//
//  OKAddTeacherViewController.m
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 30.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKAddTeacherViewController.h"
#import "OKDataManager.h"
#import "OKTeacher+CoreDataProperties.h"
#import "OKCourse+CoreDataProperties.h"

@interface OKAddTeacherViewController ()

@property (nonatomic, strong) NSArray* allTeachers;
@property (nonatomic, strong) OKTeacher* teacherOnCourse;
@property (nonatomic, strong) NSIndexPath* selectedRowAtIndexPath;

@end

@implementation OKAddTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(actionSave:)];
    self.navigationItem.rightBarButtonItem = save;
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionBack:)];
    self.navigationItem.leftBarButtonItem = back;
    
    NSManagedObjectContext* context = [OKDataManager sharedManager].persistentContainer.viewContext;
    NSFetchRequest* fetchRequest = [NSFetchRequest new];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"OKTeacher"
                                                   inManagedObjectContext:context];
    [fetchRequest setEntity:description];
    
    NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    self.allTeachers = [context executeFetchRequest:fetchRequest error:nil];
    
    if (self.teacher) {
        self.teacherOnCourse = self.teacher;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)actionSave:(UIBarButtonItem*)sender {
    
    if (self.selectedRowAtIndexPath) {
        self.delegate.delegateTeacher = [self.allTeachers objectAtIndex:self.selectedRowAtIndexPath.row];
    } else {
        self.delegate.delegateTeacher = nil;
    }
    
    [self actionBack:sender];
}

- (void)actionBack:(UIBarButtonItem*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allTeachers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"Cell";
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    OKTeacher* teacher = [self.allTeachers objectAtIndex:indexPath.row];
    NSString* text = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];
    cell.textLabel.text = text;
    
    if ([(NSString*)teacher.gender isEqualToString:@"Male"]) {
        cell.imageView.image = [UIImage imageNamed:@"teacher_male.png"];
    } else if ([(NSString*)teacher.gender isEqualToString:@"Female"]) {
        cell.imageView.image = [UIImage imageNamed:@"teacher_female.png"];
    }
    
    for (int i = 0; i < self.allTeachers.count; i++) {
        
        if ([teacher isEqual:self.teacherOnCourse]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedRowAtIndexPath = indexPath;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView cellForRowAtIndexPath:self.selectedRowAtIndexPath].accessoryType = UITableViewCellAccessoryNone;
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedRowAtIndexPath = indexPath;
}

@end
