//
//  OKNewTeacherTableViewController.m
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 29.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKNewTeacherTableViewController.h"
#import "OKDataManager.h"
#import "OKCourse+CoreDataProperties.h"

@interface OKNewTeacherTableViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) UITextField* firstNameTextField;
@property (nonatomic, strong) UITextField* lastNameTextField;
@property (nonatomic, strong) UIImageView* imageView;

@property (nonatomic, strong) NSMutableArray* allCourses;

@end

@implementation OKNewTeacherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(actionSave:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    if (self.teacher) {
        self.navigationItem.title = @"Teacher:";
        
        self.allCourses = [NSMutableArray arrayWithArray:[self.teacher.course allObjects]];

    } else {
        self.navigationItem.title = @"Add New Teacher:";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTeacher:(OKTeacher *)newTeacher {
    if (_teacher != newTeacher) {
        _teacher = newTeacher;
    }
}

#pragma mark - Actions

- (void)actionSave:(UIBarButtonItem*)sender {
    
    NSManagedObjectContext* managedObjectContext = [OKDataManager sharedManager].persistentContainer.viewContext;
    
    if (!self.teacher) {
        
        OKTeacher* teacher = [NSEntityDescription insertNewObjectForEntityForName:@"OKTeacher"
                                                           inManagedObjectContext:managedObjectContext];
        
        teacher.firstName = self.firstNameTextField.text;
        teacher.lastName = self.lastNameTextField.text;
        teacher.gender = self.segmentedControl.selectedSegmentIndex ? @"Female" : @"Male";
        
    } else {
        
        self.teacher.firstName = self.firstNameTextField.text;
        self.teacher.lastName = self.lastNameTextField.text;
        self.teacher.gender = self.segmentedControl.selectedSegmentIndex ? @"Female" : @"Male";
                
    }
    
    [[OKDataManager sharedManager] saveContext];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)actionSegmentedControl:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        self.imageView.image = [UIImage imageNamed:@"teacher_male.png"];
    } else if (sender.selectedSegmentIndex == 1) {
        self.imageView.image = [UIImage imageNamed:@"teacher_female.png"];
    }
}

#pragma mark - Methods

- (UITextField*)createTextFieldWithCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0,
                                                                           CGRectGetWidth(cell.bounds),
                                                                           CGRectGetHeight(cell.bounds))];
    
    textField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor blueColor];
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.returnKeyType = UIReturnKeyNext;
    textField.delegate = self;
    
    if (self.teacher) {
        
        if (indexPath.row == 2) {
            textField.text = self.teacher.firstName;
            self.firstNameTextField = textField;
        } else if (indexPath.row == 4) {
            textField.text = self.teacher.lastName;
            self.lastNameTextField = textField;
            textField.returnKeyType = UIReturnKeyDone;
        }
        
    } else {
        
        if (indexPath.row == 2) {
            textField.placeholder = @"Enter First Name";
            self.firstNameTextField = textField;
        } else if (indexPath.row == 4) {
            textField.placeholder = @"Enter Last Name";
            self.lastNameTextField = textField;
            textField.returnKeyType = UIReturnKeyDone;
        }
        
    }
    
    return textField;
}

- (UILabel*)createLabelWithCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                               CGRectGetWidth(cell.bounds),
                                                               CGRectGetHeight(cell.bounds))];
    
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.row == 1) {
        label.text = @"First Name:";
    } else if (indexPath.row == 3) {
        label.text = @"Last Name:";
    }
    
    return label;
}

- (UISegmentedControl*)createSegmentedControlWithCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    UISegmentedControl* segmentedControl =
    [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Male", @"Female", nil]];
    
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    
    segmentedControl.center = cell.center;
    segmentedControl.bounds = CGRectMake(0, 0, CGRectGetWidth(cell.bounds) / 2,
                                         CGRectGetHeight(cell.bounds) / 2);
    
    if ([(NSString*)self.teacher.gender isEqualToString:@"Male"]) {
        segmentedControl.selectedSegmentIndex = 0;
    } else if ([(NSString*)self.teacher.gender isEqualToString:@"Female"]) {
        segmentedControl.selectedSegmentIndex = 1;
    } else {
        segmentedControl.selectedSegmentIndex = 0;
    }
    
    [segmentedControl addTarget:self action:@selector(actionSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl = segmentedControl;
    
    return segmentedControl;
}

- (UIImageView*)createImageViewWithCell:(UITableViewCell*)cell {
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    
    imageView.center = cell.center;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    if ([(NSString*)self.teacher.gender isEqualToString:@"Female"]) {
        imageView.image = [UIImage imageNamed:@"teacher_female.png"];
    } else {
        imageView.image = [UIImage imageNamed:@"teacher_male.png"];
    }
    
    self.imageView = imageView;
    
    return imageView;
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.allCourses.count > 0) {
        if (section == 1) {
            return @"All Courses:";
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.allCourses) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.allCourses) {
        if (section == 1) {
            return self.allCourses.count;
        }
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UISegmentedControl* segmentedControl = [self createSegmentedControlWithCell:cell indexPath:indexPath];
        [cell addSubview:segmentedControl];
        
        UIImageView* imageView = [self createImageViewWithCell:cell];
        [cell addSubview:imageView];
        
    } else if (indexPath.section == 0 && (indexPath.row % 2) != 0) {
        
        UILabel* label = [self createLabelWithCell:cell indexPath:indexPath];
        [cell addSubview:label];
        
    } else if (indexPath.section == 0 && (indexPath.row % 2) == 0) {
        
        UITextField* textField = [self createTextFieldWithCell:cell indexPath:indexPath];
        [cell addSubview:textField];
        
    } else if (indexPath.section == 1) {
        
        OKCourse* course = [self.allCourses objectAtIndex:indexPath.row];
        NSString* string = [NSString stringWithFormat:@"%@ (%@)", course.courseName, course.disciplineName];
        
        cell.textLabel.text = string;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 200.f;
    }
    return 44.f;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.firstNameTextField]) {
        [self.lastNameTextField becomeFirstResponder];
    } else if ([textField isEqual:self.lastNameTextField]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    return YES;
}

@end
