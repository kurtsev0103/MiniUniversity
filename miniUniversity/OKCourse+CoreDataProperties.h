//
//  OKCourse+CoreDataProperties.h
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 01.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKCourse+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OKCourse (CoreDataProperties)

+ (NSFetchRequest<OKCourse *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *courseName;
@property (nullable, nonatomic, copy) NSString *disciplineName;
@property (nullable, nonatomic, retain) NSSet<OKStudent *> *student;
@property (nullable, nonatomic, retain) OKTeacher *teacher;

@end

@interface OKCourse (CoreDataGeneratedAccessors)

- (void)addStudentObject:(OKStudent *)value;
- (void)removeStudentObject:(OKStudent *)value;
- (void)addStudent:(NSSet<OKStudent *> *)values;
- (void)removeStudent:(NSSet<OKStudent *> *)values;

@end

NS_ASSUME_NONNULL_END
