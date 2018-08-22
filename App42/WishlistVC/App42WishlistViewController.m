     //
//  App42WishlistViewController.m
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42WishlistViewController.h"
#import "App42Constant.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "App42WishlistTableViewCell.h"
#import "App42ProductDataModel.h"
#import "App42ModelDataModel.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "App42CoreDataHandler.h"
#import "App42CommonMethods.h"

@interface App42WishlistViewController ()
{
//    StorageService *storageService;
}
@property (nonatomic, strong) NSMutableArray *whislistArray;

@end

@implementation App42WishlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Wishlist";
    
    self.wishlistTableView.delegate = self;
    self.wishlistTableView.dataSource = self;
    
    
    
//    storageService = [App42API buildStorageService];
    
    [self getWishlistData];
    
    
}

-(void)getWishlistData {
    self.whislistArray = [App42CommonMethods getAllWishlistData];
    [self.wishlistTableView reloadData];
}

//-(void)getWishlistDataFromStorage {
//
//    [storageService findAllDocuments:kApp42DataBaseName collectionName:kApp42ProductCollectionName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
//        if (success)
//        {
//            Storage *storage = (Storage*)responseObj;
//
//            NSMutableArray *jsonDocArray = storage.jsonDocArray;
//            for(JSONDocument *jsonDoc in jsonDocArray)
//            {
//                NSLog(@"json doc: %@", jsonDoc.jsonDoc);
//                NSError *error;
//                App42ProductDataModel *product = [App42ProductDataModel fromJSON:jsonDoc.jsonDoc encoding:NSUTF8StringEncoding error:&error];
//                [self.whislistArray addObject:product];
//            }
//            [self.wishlistTableView reloadData];
//        }
//        else
//        {
//            NSLog(@"Exception = %@",[exception reason]);
//            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
//            NSLog(@"App Error Code = %d",[exception appErrorCode]);
//            NSLog(@"User Info = %@",[exception userInfo]);
//        }
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    if (self.isFromHome) {
        return NO;
    }
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    App42ProductDataModel *prodDM = [self.whislistArray objectAtIndex:indexPath.row];
//    NSArray *modelArray = prodDM.models;
//    App42ModelDataModel *modelDM = modelArray[0];

    NSManagedObject *wishlistData = [self.whislistArray objectAtIndex:indexPath.row];
    
    App42WishlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wishlistCell" forIndexPath:indexPath];
    cell.titleLabel.text = [wishlistData valueForKey:kNameAttribute];
    cell.descriptionLabel.text = [wishlistData valueForKey:kDescriptionAttribute];
    cell.totalAmountLabel.text = [wishlistData valueForKey:kAmountAttribute];// modelDM.amount;
    NSLog(@"wislst model id: %ld", [wishlistData valueForKey:kModelIDAttribute]);
    [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:[wishlistData valueForKey:kIconURLAttribute]]];
    
    [cell.addButton addTarget:self action:@selector(moveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.removeButton addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.whislistArray count];
}


-(void)removeButtonClick:(UIButton *)sender {
    
    App42WishlistTableViewCell* cell = (App42WishlistTableViewCell *)sender.superview.superview;
    NSIndexPath* pathOfTheCell = [self.wishlistTableView indexPathForCell:cell];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    NSLog(@"remove from wishlist button index value: %d", rowOfTheCell);
//    App42ModelDataModel *saveWishlistData = self.whislistArray[rowOfTheCell];
    
    BOOL isDataSave = [App42CoreDataHandler deleteData:kWishlistEntityName index:rowOfTheCell];
    if (isDataSave) {
        NSLog(@"wishlist data delete successfully");
    }
    
    [self getWishlistData];

}

-(void)moveButtonClick:(UIButton *)sender {
    App42WishlistTableViewCell* tableView = (App42WishlistTableViewCell *)sender.superview.superview;
    NSIndexPath* pathOfTheCell = [self.wishlistTableView indexPathForCell:tableView];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    
    NSManagedObject *wishlistData = [self.whislistArray objectAtIndex:rowOfTheCell];
    App42ModelDataModel *modeldata = [[App42ModelDataModel alloc] init];
    modeldata.name = [wishlistData valueForKey:kNameAttribute];
    modeldata.theDescription = [wishlistData valueForKey:kDescriptionAttribute];
    modeldata.amount = [wishlistData valueForKey:kAmountAttribute];
    modeldata.modelID = [wishlistData valueForKey:kModelIDAttribute];
    modeldata.iconURL = [wishlistData valueForKey:kIconURLAttribute];
    
    
    BOOL isSaveData = [App42CoreDataHandler saveDataTotheEntity:kAddToCartEntityName modelData:modeldata];
    if (isSaveData) {
        NSLog(@"add to cart data saved successfully");
    }

    BOOL isDataSave = [App42CoreDataHandler deleteData:kWishlistEntityName index:rowOfTheCell];
    if (isDataSave) {
        NSLog(@"wishlist data removed successfully");
    }
    
    [self getWishlistData];
    
    NSLog(@"move to cart button index value: %d", rowOfTheCell);
}


@end
