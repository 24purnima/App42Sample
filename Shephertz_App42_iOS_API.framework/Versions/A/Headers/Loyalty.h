//
//  Loyalty.h
//  Shephertz_App42_iOS_API
//
//  Created by Purnima Singh on 18/07/18.
//  Copyright © 2018 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "App42Response.h"

@interface Loyalty : App42Response
{
    NSString *dbName;
    NSString *collectionName;
    NSMutableArray *jsonDocArray;
}
/*!
 *set and get the name of the database.
 */
@property(nonatomic,retain) NSString *dbName;

/*!
 *set and get the name of the database.
 */
@property(nonatomic,assign) int recordCount;

/*!
 *set and get the collection name of storage.
 */
@property(nonatomic,retain) NSString *collectionName;

/*!
 *set and get the jsonDocArray for Storage Object which contains JSONDocument Objects.
 */
@property(nonatomic,retain) NSMutableArray *jsonDocArray;

-(void)clearMemory;



//@property (nonatomic, assign) NSInteger earnPoints;
//@property (nonatomic, assign) NSInteger redeemPoints;
//@property (nonatomic, copy)   NSString *lastTier;
//@property (nonatomic, copy)   NSString *email;
//@property (nonatomic, copy)   NSString *userID;
//@property (nonatomic, copy)   NSString *userName;
//@property (nonatomic, assign) NSInteger lng;
//@property (nonatomic, copy)   NSString *currentTier;
//@property (nonatomic, assign) NSInteger lat;
//@property (nonatomic, copy)   NSString *mobile;
//@property (nonatomic, assign) NSInteger totalPoints;

@end
