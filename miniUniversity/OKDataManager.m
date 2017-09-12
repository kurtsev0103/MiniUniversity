//
//  OKDataManager.m
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 28.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKDataManager.h"
#import "OKStudent+CoreDataProperties.h"
#import "OKTeacher+CoreDataProperties.h"
#import "OKCourse+CoreDataProperties.h"

@implementation OKDataManager

static int namesCount = 100;

static NSString* gender[] = {
    @"Male", @"Female"
};

static NSString* firstMaleNames[] = {
    @"Aaron",    @"Adam",    @"Alan",    @"Albert",  @"Alex",     @"Rob",     @"Alfred",  @"Andrew",   @"Andy"     @"Anthony",
    @"Arnold",   @"Arthur",  @"Barry",   @"Ben",     @"Benjamin", @"Bernard", @"Bill",    @"Billy",    @"Bob",     @"Bobby",
    @"Brad",     @"Brandon", @"Brian",   @"Bruce",   @"Bryan",    @"Bud",     @"Calvin",  @"Carl",     @"Carlos"   @"Charles",
    @"Charlie",  @"Chris",   @"Oliver",  @"Paul",    @"Colin",    @"Connie",  @"Curtis",  @"Dale",     @"Dan",     @"Daniel",
    @"Danny",    @"Dave",    @"David",   @"Davis",   @"Dean",     @"Dennis",  @"Derek",   @"Dick",     @"Don",     @"Donald",
    @"Douglas",  @"Duke",    @"Dustin",  @"Dylan",   @"Earl",     @"Edgar",   @"Edmond",  @"Edward",   @"Edwin",   @"Elton",
    @"Emmett",   @"Eric",    @"Ernest",  @"Ethan",   @"Felix",    @"Rick",    @"Floyd",   @"Francis",  @"Frank",   @"Fred",
    @"Fuller",   @"Gary",    @"George",  @"Gerald",  @"Gilbert",  @"Glover",  @"Gordon",  @"Graham",   @"Greg",    @"Harold",
    @"Harrison", @"Harry",   @"Henry",   @"Herbert", @"Howard",   @"Jack",    @"Jake",    @"James",    @"Jay",     @"Jeff",
    @"Jerry",    @"Jim",     @"Joel",    @"John",    @"Johnny",   @"Kane",    @"Keith",   @"Kurt",     @"Larry",   @"Leo"
};

static NSString* firstFemaleNames[] = {
    @"Abby",    @"Ada",      @"Adriana", @"Jean",    @"Aimee",    @"Alana",   @"Alexa",   @"Ann",      @"Alice",   @"Jasmine",
    @"Alyssa",  @"Amanda",   @"Amber",   @"Amy",     @"Ana",      @"Andrea",  @"Angela",  @"Anita",    @"Alison",  @"Monica",
    @"Anna",    @"Annette",  @"Annie",   @"Aria",    @"Ashley",   @"Audrey",  @"Barbara", @"Beatrice", @"Becky",   @"Nancy",
    @"Belinda", @"Bertha",   @"Beryl",   @"Beth",    @"Betty",    @"Beverly", @"Bonnie",  @"Brandi",   @"Brenda",  @"Nicole",
    @"Camille", @"Candice",  @"Carly",   @"Carmen",  @"Carol",    @"Olga",    @"Carrie",  @"Evelyn",   @"Helena",  @"Patricia",
    @"Cathy",   @"Chantal",  @"Janet",   @"Cheryl",  @"Сhris",    @"Jamie",   @"Janice",  @"Christy",  @"Holly",   @"Paula",
    @"Cindy",   @"Claire",   @"Сlara",   @"Connie",  @"Jane",     @"Crystal", @"Dana",    @"Dawn",     @"Debbie",  @"Peggy",
    @"Deborah", @"Denise",   @"Diana",   @"Diane",   @"Donna",    @"Doris",   @"Dorothy", @"Eliza",    @"Jade",    @"Penelope",
    @"Ella",    @"Ellen",    @"Emily",   @"Emma",    @"Erika",    @"Erin",    @"Esther",  @"Ethel",    @"Eva",     @"Victoria",
    @"Faith",   @"Fiona",    @"Gina",    @"Gloria",  @"Grace",    @"Hannah",  @"Hayley",  @"Heather",  @"Helen",   @"Irene"
};

static NSString* lastNames[] = {
    @"Korol",   @"Andrews",  @"Arnold",  @"Arthurs", @"Atcheson", @"Attwood", @"Audley",  @"Austin",   @"Ayrton",  @"Babcock",
    @"Backer",  @"Baldwin",  @"Bargem",  @"Barnes",  @"Bawerman", @"Becker",  @"Benson",  @"Birch",    @"Bishop",  @"Black",
    @"Blare",   @"Boolman",  @"Bootman", @"Boswort", @"Brooks",   @"Brown",   @"Bush",    @"Calhoun",  @"Cambell", @"Carey",
    @"Carroll", @"Carter",   @"Chand",   @"Chapman", @"Charlson", @"Clapton", @"Lifford", @"Coleman",  @"Conors",  @"Cook",
    @"Cramer",  @"Crofton",  @"Cross",   @"Daniels", @"Davidson", @"Day",     @"Dean",    @"Derrick",  @"Dodson",  @"Donovan",
    @"Douglas", @"Dowman",   @"Dutton",  @"Duncan",  @"Dunce",    @"Durham",  @"Dyson",   @"Edwards",  @"Elmers",  @"Enderson",
    @"Odnoral", @"Evans",    @"Faber",   @"Fane",    @"Farmer",   @"Farrell", @"Fergus",  @"Finch",    @"Fisher",  @"Fitzgerald",
    @"Kurtsev", @"Fleming",  @"Ford",    @"Forman"   @"Forster",  @"Foster",  @"Francis", @"Fraser",   @"Freeman", @"Fulton",
    @"Gardner", @"Garrison", @"Gate",    @"Gerald",  @"Howard",   @"Jacobs",  @"James",   @"Jeff",     @"Jenkin",  @"Johnson",
    @"Jerome",  @"Johnson",  @"Jones",   @"Keat",    @"Kelly",    @"Kendal",  @"Kennedy", @"Kennett",  @"Miller",  @"Philips"
};

+ (OKDataManager*)sharedManager {
    static OKDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [OKDataManager new];
    });
    
    return manager;
}

#pragma mark - Methods

- (OKStudent*)generateRandomStudent {
    OKStudent* student = [NSEntityDescription insertNewObjectForEntityForName:@"OKStudent"
                                                       inManagedObjectContext:self.persistentContainer.viewContext];
    
    student.gender = gender[arc4random_uniform(2)];
    
    if ([(NSString*)student.gender isEqualToString:@"Male"]) {
        student.firstName = firstMaleNames[arc4random_uniform(namesCount)];
    } else {
        student.firstName = firstFemaleNames[arc4random_uniform(namesCount)];
    }
    
    student.lastName = lastNames[arc4random_uniform(namesCount)];
    
    NSString* mail = [NSString stringWithFormat:@"%@%@@gmail.com", student.lastName, student.firstName];
    student.mail = [mail localizedLowercaseString];
    
    return student;
}

- (OKTeacher*)generateRandomTeacher {
    OKTeacher* teacher = [NSEntityDescription insertNewObjectForEntityForName:@"OKTeacher"
                                                       inManagedObjectContext:self.persistentContainer.viewContext];
    
    teacher.gender = gender[arc4random_uniform(2)];
    
    if ([(NSString*)teacher.gender isEqualToString:@"Male"]) {
        teacher.firstName = firstMaleNames[arc4random_uniform(namesCount)];
    } else {
        teacher.firstName = firstFemaleNames[arc4random_uniform(namesCount)];
    }
    
    teacher.lastName = lastNames[arc4random_uniform(namesCount)];
    
    return teacher;
}

- (NSArray*)generateCourses {
    OKCourse* iOScourse = [NSEntityDescription insertNewObjectForEntityForName:@"OKCourse"
                                                         inManagedObjectContext:self.persistentContainer.viewContext];
    
    iOScourse.courseName = @"iOS Development Course Beginner";
    iOScourse.disciplineName = @"objective-c";
    
    OKCourse* iOScourse2 = [NSEntityDescription insertNewObjectForEntityForName:@"OKCourse"
                                                         inManagedObjectContext:self.persistentContainer.viewContext];
    
    iOScourse2.courseName = @"Swift Development Course Beginner";
    iOScourse2.disciplineName = @"swift";
    
    OKCourse* seoCourse = [NSEntityDescription insertNewObjectForEntityForName:@"OKCourse"
                                                        inManagedObjectContext:self.persistentContainer.viewContext];
    
    seoCourse.courseName = @"Magic with Google";
    seoCourse.disciplineName = @"SEO";
    
    OKCourse* graphicsCourse = [NSEntityDescription insertNewObjectForEntityForName:@"OKCourse"
                                                             inManagedObjectContext:self.persistentContainer.viewContext];
    
    graphicsCourse.courseName = @"Graphics";
    graphicsCourse.disciplineName = @"Photoshop";
    
    OKCourse* htmlCourse = [NSEntityDescription insertNewObjectForEntityForName:@"OKCourse"
                                                         inManagedObjectContext:self.persistentContainer.viewContext];
    
    htmlCourse.courseName = @"Website development";
    htmlCourse.disciplineName = @"HTML";
    
    return [NSArray arrayWithObjects:iOScourse, iOScourse2, seoCourse, graphicsCourse, htmlCourse, nil];
}

- (NSArray*)allObjects {

    NSFetchRequest* request = [NSFetchRequest new];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"OKParent"
                                                   inManagedObjectContext:self.persistentContainer.viewContext];
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.persistentContainer.viewContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    return resultArray;
}

- (void)printAllObjects {
    
    NSArray* allObjects = [self allObjects];
    
    for (id object in allObjects) {
        
        if ([object isKindOfClass:[OKStudent class]]) {
            
            OKStudent* student = (OKStudent*)object;
            NSLog(@"Student: %@ %@ (%@) - mail: %@", student.firstName, student.lastName,
                                                        student.gender, student.mail);
        } else if ([object isKindOfClass:[OKTeacher class]]) {
            
            OKTeacher* teacher = (OKTeacher*)object;
            NSLog(@"Teacher: %@ %@ - course: %@, %@", teacher.firstName, teacher.lastName,
                  [teacher.course anyObject].courseName, [teacher.course anyObject].disciplineName);
            
        } else if ([object isKindOfClass:[OKCourse class]]) {
            
            OKCourse* course = (OKCourse*)object;
            NSLog(@"Course: %@ %@ - teacher: %@ %@", course.courseName, course.disciplineName,
                                                        course.teacher.firstName, course.teacher.lastName);
            
        }
    }
}

- (void)deleteAllObjects {
    
    NSArray* allObjects = [self allObjects];
    
    for (id object in allObjects) {
        [self.persistentContainer.viewContext deleteObject:object];
    }
    [self saveContext];
}

- (void)generateAndAddRandomDataBase {
    
    NSArray* allCourses = [self generateCourses];
    NSMutableArray* courses = [NSMutableArray arrayWithArray:allCourses];
    
    for (int i = 0; i < 5; i++) {
        OKTeacher* teacher = [self generateRandomTeacher];
        OKCourse* course = [courses objectAtIndex:arc4random_uniform((int)courses.count)];
        teacher.course = [NSSet setWithObject:course];
        
        [courses removeObject:course];
    }
    
    for (int i = 0; i < 30; i++) {
        OKStudent* student = [self generateRandomStudent];
        int courseCount = arc4random_uniform(5) + 1;
        
        while (student.course.count < courseCount) {
            OKCourse* course = [allCourses objectAtIndex:arc4random_uniform(5)];
            if (![student.course containsObject:course]) {
                [student addCourseObject:course];
            }
        }
    }
    
    [self saveContext];
    [self printAllObjects];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"miniUniversity"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
