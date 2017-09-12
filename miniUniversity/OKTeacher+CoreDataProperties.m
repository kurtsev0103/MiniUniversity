//
//  OKTeacher+CoreDataProperties.m
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 01.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKTeacher+CoreDataProperties.h"

@implementation OKTeacher (CoreDataProperties)

+ (NSFetchRequest<OKTeacher *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"OKTeacher"];
}

@dynamic firstName;
@dynamic gender;
@dynamic lastName;
@dynamic course;

@end
