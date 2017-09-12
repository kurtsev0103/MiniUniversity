//
//  OKTeacher+CoreDataProperties.h
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 01.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKTeacher+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OKTeacher (CoreDataProperties)

+ (NSFetchRequest<OKTeacher *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, retain) NSSet<OKCourse *> *course;

@end

@interface OKTeacher (CoreDataGeneratedAccessors)

- (void)addCourseObject:(OKCourse *)value;
- (void)removeCourseObject:(OKCourse *)value;
- (void)addCourse:(NSSet<OKCourse *> *)values;
- (void)removeCourse:(NSSet<OKCourse *> *)values;

@end

NS_ASSUME_NONNULL_END
