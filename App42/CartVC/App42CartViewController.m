//
//  App42CartViewController.m
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42CartViewController.h"
#import "App42Constant.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "App42WishlistTableViewCell.h"
#import "App42ProductDataModel.h"
#import "App42ModelDataModel.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "App42CoreDataHandler.h"
#import "App42PaymentViewController.h"


@interface App42CartViewController ()
{
//    StorageService *storageService;
}
@property (nonatomic, strong) NSMutableArray *cartArray;
@end

@implementation App42CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Cart";
    
    self.cartTableView.dataSource = self;
    self.cartTableView.delegate = self;
    
//    self.cartArray = [NSMutableArray new];
//    storageService = [App42API buildStorageService];
    
//    [self getCartDataFromStorage];
    
    
    [self geAddtocartData];
}

-(void)geAddtocartData {
    
    self.cartArray = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kAddToCartEntityName];
    self.cartArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"cart array: %@", self.cartArray);

    int totalAmountValue = 0;
    
    for (NSManagedObject *obj in self.cartArray) {
        totalAmountValue += [[obj valueForKey:kAmountAttribute] intValue];
    }
    NSLog(@"TotalAMountValue: %d", totalAmountValue);
    
    self.totalAmountlabel.text = [NSString stringWithFormat:@"%d", totalAmountValue];
    
    [self.cartTableView reloadData];
}

//-(void)getCartDataFromStorage {
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
//                [self.cartArray addObject:product];
//            }
//            [self.cartTableView reloadData];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *addtocartData = [self.cartArray objectAtIndex:indexPath.row];
    
//    App42ProductDataModel *prodDM = [self.cartArray objectAtIndex:indexPath.row];
    //    NSArray *modelArray = prodDM.models;
    //    App42ModelDataModel *modelDM = modelArray[0];
    App42WishlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell" forIndexPath:indexPath];
    cell.titleLabel.text = [addtocartData valueForKey:kNameAttribute];;
    cell.descriptionLabel.text = [addtocartData valueForKey:kDescriptionAttribute];
    cell.totalAmountLabel.text = [addtocartData valueForKey:kAmountAttribute];// modelDM.amount;
    
    [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:[addtocartData valueForKey:kIconURLAttribute]]];
    
    [cell.removeButton addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addButton addTarget:self action:@selector(moveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cartArray count];
}

-(void)removeButtonClick:(UIButton *)sender {
    
    App42WishlistTableViewCell* cell = (App42WishlistTableViewCell *)sender.superview.superview;
    NSIndexPath* pathOfTheCell = [self.cartTableView indexPathForCell:cell];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    
    NSLog(@"remove from cart button index value: %d", pathOfTheCell.row);
    BOOL isDataSave = [App42CoreDataHandler deleteData:kAddToCartEntityName index:rowOfTheCell];
    if (isDataSave) {
        NSLog(@"remove cart data successfully");
    }
    
    [self geAddtocartData];
}

-(void)moveButtonClick:(UIButton *)sender {
    App42WishlistTableViewCell* tableView = (App42WishlistTableViewCell *)sender.superview.superview;
    NSIndexPath* pathOfTheCell = [self.cartTableView indexPathForCell:tableView];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    
    NSLog(@"move to wishlist button index value: %d", rowOfTheCell);
    
    NSManagedObject *cartData = [self.cartArray objectAtIndex:rowOfTheCell];
    App42ModelDataModel *modeldata = [[App42ModelDataModel alloc] init];
    modeldata.name = [cartData valueForKey:kNameAttribute];
    modeldata.theDescription = [cartData valueForKey:kDescriptionAttribute];
    modeldata.amount = [cartData valueForKey:kAmountAttribute];
    modeldata.modelID = [cartData valueForKey:kModelIDAttribute];
    modeldata.iconURL = [cartData valueForKey:kIconURLAttribute];
    
    BOOL isDataSave = [App42CoreDataHandler deleteData:kAddToCartEntityName index:rowOfTheCell];
    if (isDataSave) {
        NSLog(@"remove cart data successfully");
    }
    
    [self geAddtocartData];
    
    BOOL isSaveData = [App42CoreDataHandler saveDataTotheEntity:kWishlistEntityName modelData:modeldata];
    if (isSaveData) {
        NSLog(@"add to wishlist data saved successfully");
    }
    
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"placeOrder"]) {
//        App42PaymentViewController *payementVC = segue.destinationViewController;
//        payementVC.amountvalue = self.totalAmountlabel.text;
    }
}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    if (self.isFromFeature == true)
        return NO;
    else
        return YES;
}


- (IBAction)placeOrderButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"placeOrder" sender:self];
}
@end
