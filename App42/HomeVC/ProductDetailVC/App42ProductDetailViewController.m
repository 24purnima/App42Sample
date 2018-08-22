//
//  App42ProductDetailViewController.m
//  App42
//
//  Created by Purnima Singh on 29/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42ProductDetailViewController.h"
#import "App42ProductDetailTableViewCell.h"
#import "App42ModelDataModel.h"
#import "UIImageView+WebCache.h"
#import "App42ProductFeatureViewController.h"
#import "ProductDetailHeaderView.h"
#import "UIColor+UIColor_HexValue.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "App42Constant.h"
#import "App42CoreDataHandler.h"
#import "App42CommonMethods.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "App42RecommendationViewController.h"
#import "MBProgressHUD.h"
#import "ProductFooterView.h"
#import "RecommededTableViewCell.h"
#import "RecommenderCollectionViewCell.h"

@interface App42ProductDetailViewController () <recommendProtocol>
{
    App42ModelDataModel *productModel;
    NSUInteger indexValue;
    int numberOfSection;
    BOOL isFiltered;
}
@property (nonatomic, strong) NSMutableArray *getRecommendedArray;
@property (nonatomic, copy) NSMutableArray *wishlistArray;

@end

@implementation App42ProductDetailViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.productDetailTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    numberOfSection = 1;
    
    self.productDetailTable.dataSource = self;
    self.productDetailTable.delegate = self;
    
    [self.productDetailTable setRowHeight:UITableViewAutomaticDimension];
    [self.productDetailTable setEstimatedRowHeight:295];
    
    self.title = self.productData.name;
    
    self.detailArray = [NSArray new];
    
//    App42ModelDataModel *modelData = [self.productData dis]
    self.detailArray = [self.productData.models copy];
    NSLog(@"model array: %@", self.detailArray);
    
    ProductDetailHeaderView *headerView = (ProductDetailHeaderView *)[self.productDetailTable tableHeaderView];
    headerView.titleLabel.text = self.productData.name;
    headerView.descriptionLabel.text = self.productData.theDescription;
    headerView.backgroundColor = [UIColor colorFromHexString:self.productData.cardColor];
    headerView.searchBar.userInteractionEnabled = NO;
    headerView.searchBar.barTintColor = [UIColor colorFromHexString:self.productData.cardColor];
    [headerView.thumbnail sd_setImageWithURL:[NSURL URLWithString:self.productData.imgURL]];
    headerView.searchBar.delegate = self;
    headerView.searchBar.showsCancelButton = YES;
    
    self.wishlistArray = [App42CommonMethods getAllWishlistData];
    for (App42ModelDataModel *modelData in self.detailArray) {
        NSLog(@"model id: %ld", (long)modelData.modelID);
        modelData.isWishlist = NO;
        if (self.wishlistArray) {
            for (NSManagedObject *obj in self.wishlistArray) {
                NSLog(@"obje model id: %ld", [[obj valueForKey:kModelIDAttribute] integerValue]);
                
                if (modelData.modelID == [[obj valueForKey:kModelIDAttribute] integerValue]) {
                    modelData.isWishlist = YES;
                }
            }
        }
    }
    
    productModel = [[App42ModelDataModel alloc] init];
   
//    self.productDetailTable.tableFooterView = [[UIView alloc] init];
    [self getRecommendedItemList:[App42API getLoggedInUser]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"productFeature"]) {
        App42ProductFeatureViewController *featureVC = segue.destinationViewController;
        featureVC.modelData = productModel;
        featureVC.indexValue = indexValue;
        featureVC.allProductarray = self.allproductArray;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowCount;
    if (section == 0) {
        if (isFiltered) {
            rowCount = [self.searchResults count];
        }
        else {
            rowCount = [self.detailArray count];
        }
    }
    else {
        rowCount = 1;
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        App42ProductDetailTableViewCell *cell = (App42ProductDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"productDetail" forIndexPath:indexPath];
        App42ModelDataModel *modelData;
        
        if (isFiltered) {
            modelData = self.searchResults[indexPath.row];
        }
        else {
            modelData = self.detailArray[indexPath.row];
        }
        
        NSURL *imgURL = [NSURL URLWithString:modelData.iconURL];
        [cell.thumbnail sd_setImageWithURL:imgURL];
        cell.titleLabel.text = modelData.name;
        cell.descriptionLabel.text = modelData.theDescription;
        
        NSLog(@"is wishlist: %d", modelData.isWishlist);
        
        if (modelData.isWishlist) {
            [cell.wishlistButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        }
        else {
            [cell.wishlistButton setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        }
        
        [cell.wishlistButton addTarget:self action:@selector(wishlistButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addToCartButton addTarget:self action:@selector(addtocartButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else {
        RecommededTableViewCell *cell = (RecommededTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
        //pageControl = cell.recommedPageControl;
        [cell setCollectionViewData:self.getRecommendedArray allProuctArray:self.allproductArray];
        cell.delegate = self;
        return cell;
    }
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 245;
    }
    else {
        return 287;
    }
//    return 245;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    productModel = self.detailArray[indexPath.row];
    indexValue = indexPath.row;
    [self performSegueWithIdentifier:@"productFeature" sender:self];
}



-(void)wishlistButtonClick:(UIButton *)sender {
    
    App42ProductDetailTableViewCell* tableView = (App42ProductDetailTableViewCell *)sender.superview.superview.superview;
    NSIndexPath* pathOfTheCell = [self.productDetailTable indexPathForCell:tableView];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    App42ModelDataModel *saveWishlistData = self.detailArray[rowOfTheCell];
      
    
    if ([sender.currentImage isEqual:[UIImage imageNamed:@"unlike"]]) {
        [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];        
        
        [App42CommonMethods addOrUpdatePreference:saveWishlistData];
        
        BOOL isDataSave = [App42CoreDataHandler saveDataTotheEntity:kWishlistEntityName modelData:saveWishlistData];
        if (isDataSave) {
            NSLog(@"wishlist data saved successfully");
        }
    }
    else {
        [sender setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        
        BOOL isDataDelete = [App42CoreDataHandler deleteCoreDataUsingModelId:saveWishlistData.modelID entityname:kWishlistEntityName];
        if (isDataDelete) {
            NSLog(@"wishlist data delete successfully");
        }
        
//        NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        NSEntityDescription *entity = [NSEntityDescription entityForName:kWishlistEntityName inManagedObjectContext:context];
//        [fetchRequest setEntity:entity];
//        
//        NSError *error;
//        [context deleteObject:self.detailArray[rowOfTheCell]];
//        
//        NSLog(@"object deleted");
//        
//        if (![context save:&error])
//        {
//            NSLog(@"Error deleting  - error:%@",error);
//        }
        
        
//        BOOL isDataDelete = [App42CoreDataHandler deleteData:kWishlistEntityName index:rowOfTheCell];
//        if (isDataDelete) {
//            NSLog(@"wishlist data delete successfully");
//        }
    }
}

-(void)addtocartButtonClick:(UIButton *)sender {
    
    App42ProductDetailTableViewCell* tableView = (App42ProductDetailTableViewCell *)sender.superview.superview;
    NSIndexPath* pathOfTheCell = [self.productDetailTable indexPathForCell:tableView];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    App42ModelDataModel *saveWishlistData = self.detailArray[rowOfTheCell];
    
    
    
    if ([[sender.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"ADD TO CART"]) {
//        [sender setTitle:@"  ADDED TO CART" forState:UIControlStateNormal];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];  //Activity Indicator loading
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            BOOL isDataSave = [App42CoreDataHandler saveDataTotheEntity:kAddToCartEntityName modelData:saveWishlistData];
            if (isDataSave) {
                NSLog(@"add to cart data saved successfully");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES]; //hide that after your Dela Loading finished fromDatabase
            });
        });

        
    }
    else {
//        [sender setTitle:@"  ADD TO CART" forState:UIControlStateNormal];
//        
//        BOOL isDataDelete = [App42CoreDataHandler deleteData:kAddToCartEntityName index:rowOfTheCell];
//        if (isDataDelete) {
//            NSLog(@"add to cart data delete successfully");
//        }
        
    }
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResults removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    
    self.searchResults = [NSMutableArray arrayWithArray: [self.detailArray filteredArrayUsingPredicate:resultPredicate]];
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(persistentContainer)]) {
        context = [[delegate persistentContainer] viewContext];
    }
       
    return context;
}


-(void)getRecommendedItemList:(NSString *)userId {
    
    NSLog(@"all product array: %@", self.allproductArray);
    
    self.getRecommendedArray = [NSMutableArray new];
    [App42CommonMethods setMACredentials];
    
    int howMany = 5;
    NSString *userstr = [App42CommonMethods convertStringToHashCode:userId];
    long userid = [userstr longLongValue];
    
    RecommenderService *recommendService = [App42API buildRecommenderService];
    [recommendService itemBasedBySimilarity:EUCLIDEAN_DISTANCE userId:userid howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)      {
            Recommender *recommender =  (Recommender*)responseObj;
            NSMutableArray *recommendedItemList =  recommender.recommendedItemList;
            for(RecommendedItem *recommendedItem in recommendedItemList){
                
                for (App42ProductDataModel *productModel in self.allproductArray) {
                    NSArray *modelArray = productModel.models;
                    for (App42ModelDataModel *modelData in modelArray) {
                        if ([recommendedItem.item isEqualToString:[NSString stringWithFormat:@"%d", modelData.modelID]]) {
                            [self.getRecommendedArray addObject:modelData];
                        }
                    }
                }
            }
            
//            NSLog(@"getRecommendedArray: %@", self.getRecommendedArray);
            
            if (self.getRecommendedArray != nil && self.getRecommendedArray.count > 0) {
                [self addRecommendView];
            }
        }
        else      {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
        [App42CommonMethods setCloudAPICredentials];
    }];
}

-(void)addRecommendView
{
    numberOfSection = 2;
    [self.productDetailTable reloadData];
    
    App42RecommendationViewController *recommendVC = [self.storyboard instantiateViewControllerWithIdentifier:@"App42RecommendationViewController"];
    recommendVC.cardColorCode = self.productData.cardColor;
    recommendVC.recommendedArray = [self.getRecommendedArray mutableCopy];
    recommendVC.allproductArray = [self.allproductArray mutableCopy];
    [self addChildViewController:recommendVC];
    [self.view addSubview:recommendVC.view];
    [recommendVC didMoveToParentViewController:self];    
}


-(void)openFeaturePage:(App42ModelDataModel *)modelData {
    productModel = modelData;
    [self performSegueWithIdentifier:@"productFeature" sender:self];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        isFiltered = NO;
    }
    else {
        numberOfSection = 1;
        isFiltered = YES;
        self.searchResults = [NSMutableArray new];
        
        for (App42ModelDataModel *modelData in self.detailArray) {
            NSRange nameRange = [modelData.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [self.searchResults addObject:modelData];
            }
        }
        
        [self.productDetailTable reloadData];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    numberOfSection = 2;
    isFiltered = NO;
    [searchBar resignFirstResponder];
    [self.productDetailTable reloadData];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}


@end
