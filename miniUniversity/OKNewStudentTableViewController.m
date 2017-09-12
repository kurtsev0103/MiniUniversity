//
//  OKNewStudentTableViewController.m
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 28.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKNewStudentTableViewController.h"
#import "OKDataManager.h"
#import "OKNewCourseTableViewController.h"
#import "OKStudentViewController.h"
#import "OKCourse+CoreDataProperties.h"

@interface OKNewStudentTableViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) UITextField* firstNameTextField;
@property (nonatomic, strong) UITextField* lastNameTextField;
@property (nonatomic, strong) UITextField* mailTextField;
@property (nonatomic, strong) UIImageView* imageView;

@property (nonatomic, strong) NSMutableArray* allCourses;
@end

@implementation OKNewStudentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(actionSave:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    if (self.student) {
        self.navigationItem.title = @"Student:";
        
        self.allCourses = [NSMutableArray arrayWithArray:[self.student.course allObjects]];
        
    } else {
        self.navigationItem.title = @"Add New Student:";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setStudent:(OKStudent *)newStudent {
    if (_student != newStudent) {
        _student = newStudent;
    }
}

#pragma mark - Actions

- (void)actionSave:(UIBarButtonItem*)sender {
    
    NSManagedObjectContext* managedObjectContext = [OKDataManager sharedManager].persistentContainer.viewContext;

    if (!self.student) {
        
        OKStudent* student = [NSEntityDescription insertNewObjectForEntityForName:@"OKStudent"
                                                           inManagedObjectContext:managedObjectContext];
        
        student.firstName = self.firstNameTextField.text;
        student.lastName = self.lastNameTextField.text;
        student.mail = self.mailTextField.text;
        student.gender = self.segmentedControl.selectedSegmentIndex ? @"Female" : @"Male";
        
    } else {
        
        self.student.firstName = self.firstNameTextField.text;
        self.student.lastName = self.lastNameTextField.text;
        self.student.mail = self.mailTextField.text;
        self.student.gender = self.segmentedControl.selectedSegmentIndex ? @"Female" : @"Male";
                
    }
    
    [[OKDataManager sharedManager] saveContext];
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[OKNewCourseTableViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        } else if ([controller isKindOfClass:[OKStudentViewController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
    
}

- (void)actionSegmentedControl:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        self.imageView.image = [UIImage imageNamed:@"male_icon.png"];
    } else if (sender.selectedSegmentIndex == 1) {
        self.imageView.image = [UIImage imageNamed:@"female_icon.png"];
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
    
    if (self.student) {
        
        if (indexPath.row == 2) {
            textField.text = self.student.firstName;
            self.firstNameTextField = textField;
        } else if (indexPath.row == 4) {
            textField.text = self.student.lastName;
            self.lastNameTextField = textField;
        } else if (indexPath.row == 6) {
            textField.text = self.student.mail;
            textField.returnKeyType = UIReturnKeyDone;
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            self.mailTextField = textField;
        }
        
    } else {
        
        if (indexPath.row == 2) {
            textField.placeholder = @"Enter First Name";
            self.firstNameTextField = textField;
        } else if (indexPath.row == 4) {
            textField.placeholder = @"Enter Last Name";
            self.lastNameTextField = textField;
        } else if (indexPath.row == 6) {
            textField.placeholder = @"Enter Mail";
            textField.returnKeyType = UIReturnKeyDone;
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            self.mailTextField = textField;
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
    } else if (indexPath.row == 5) {
        label.text = @"Mail:";
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
    
    if ([(NSString*)self.student.gender isEqualToString:@"Female"]) {
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
    
    if ([(NSString*)self.student.gender isEqualToString:@"Female"]) {
        imageView.image = [UIImage imageNamed:@"female_icon.png"];
    } else {
        imageView.image = [UIImage imageNamed:@"male_icon.png"];
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
    return 7;
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
        [self.mailTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.mailTextField]) {
        
        NSString* validEmailCharacters = @".-_@1234567890abcdefghijklmnopqrstuvwxyz";
        NSCharacterSet* set = [[NSCharacterSet characterSetWithCharactersInString:validEmailCharacters] invertedSet];
        NSArray* components = [string componentsSeparatedByCharactersInSet:set];
        
        if (components.count == 1) {
            
            NSArray* componentsByAt =
            [[textField.text stringByReplacingCharactersInRange:range withString:string] componentsSeparatedByString:@"@"];
            NSString* resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
            if (componentsByAt.count <= 2 && resultString.length <= 30) {
                textField.text = resultString;
            }
            
        }
        return NO;
    }
    return YES;
}

@end
