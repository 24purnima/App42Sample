//
//  App42CoreDataHandler.m
//  App42
//
//  Created by Purnima Singh on 13/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42CoreDataHandler.h"
#import "AppDelegate.h"
#import "App42Constant.h"

@implementation App42CoreDataHandler

+(BOOL)saveDataTotheEntity:(NSString *)entityName modelData:(App42ModelDataModel *)saveModel {
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"model_id == %d", saveModel.modelID];
    [fetchRequest setPredicate:predicate];
    
    NSArray *obj = [context executeFetchRequest:fetchRequest error:nil];
    if (!obj || [obj count] <= 0) {
        // Create a new managed object
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        [newDevice setValue:saveModel.name forKey:kNameAttribute];
        [newDevice setValue:saveModel.theDescription forKey:kDescriptionAttribute];
        [newDevice setValue:saveModel.iconURL forKey:kIconURLAttribute];
        [newDevice setValue:@(saveModel.modelID) forKey:kModelIDAttribute];
        [newDevice setValue:saveModel.amount forKey:kAmountAttribute];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            return false;
        }
        return true;
    }
    else {
        NSLog(@"duplicate");
        return false;
    }    
}

+(BOOL)deleteData:(NSString *)entityName index:(NSUInteger)arrIndex {
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSMutableArray *fetchedObjects = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if (fetchedObjects == nil) {
        NSLog(@"delete did not complete successfully.");
        return false;
    }
    
    [context deleteObject:[fetchedObjects objectAtIndex:arrIndex]];
    
    NSError *error;
    if(![context save:&error]){
        NSLog(@"Error deleting: %@ - error: %@",entityName,error);
    }
    
    return true;
       
}

+(BOOL)saveLoginData:(NSString *)entityName username:(NSString *)userName accountlocked:(BOOL)accountLocked sessionid:(NSString *)sessionID email:(NSString *)email mobile:(NSString *)mobile {
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;

    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName == %@",userName];
//    [fetchRequest setPredicate:predicate];
////    [fetchRequest setFetchLimit:1];
//    [fetchRequest setEntity:entity];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName == %@", userName];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *arrResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if ([arrResult count] > 0) {
        NSLog(@"update detail");
        for (NSManagedObject *obj in arrResult) {
            [obj setValue:userName forKey:kUserNameAttribute];
            [obj setValue:sessionID forKey:kSessionIdAttribute];
            [obj setValue:email forKey:kEmailAttribute];
            [obj setValue:mobile forKey:kMobileAttribute];
            [obj setValue:@(accountLocked) forKey:kAccountLockedAttribute];
        }
        
    }
    else {
        NSLog(@"create login");
        // Create a new managed object
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        [newDevice setValue:userName forKey:kUserNameAttribute];
        [newDevice setValue:sessionID forKey:kSessionIdAttribute];
        [newDevice setValue:email forKey:kEmailAttribute];
        [newDevice setValue:mobile forKey:kMobileAttribute];
        [newDevice setValue:@(accountLocked) forKey:kAccountLockedAttribute];
    }
    
   
    

    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return false;
    }
    
    return true;
}

+(BOOL)deleteAllSavedDataFromEntity:(NSString *)nameEntity
{
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [context deleteObject:object];
    }
    
    error = nil;
    [context save:&error];
    
    if (error) {
        return false;
    }
    
    return true;
}

+(BOOL)saveLoyaltyData:(NSString *)entityName totalPoints:(NSInteger)totalPoints earnPoints:(NSInteger)earnPoints redeemPoints:(NSInteger)redeemPoints userName:(NSString *)userName userId:(NSString *)userId {
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    
    [newDevice setValue:@(totalPoints) forKey:kTotalPointsAttribute];
    [newDevice setValue:@(earnPoints) forKey:kEarnPointsAttribute];
    [newDevice setValue:@(redeemPoints) forKey:kRedeemPointsAttribute];
    [newDevice setValue:userId forKey:kUserIdAttribute];
    [newDevice setValue:userName forKey:kUserNameAttribute];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return false;
    }
    
    return true;
}

+(BOOL)deleteCoreDataUsingModelId:(NSInteger)modelId entityname:(NSString *)entityName {
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSMutableArray *fetchedObjects = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if (fetchedObjects == nil) {
        NSLog(@"delete did not complete successfully.");
        return false;
    }
    
    for (NSManagedObject *obj in fetchedObjects) {
        if ([[obj valueForKey:kModelIDAttribute] integerValue] == modelId) {
            [context deleteObject:obj];
        }
    }
    
    NSError *error = nil;
    [context save:&error];
    
    if (error) {
        return false;
    }
    
    return YES;
}
@end
