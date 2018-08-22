//
//  App42ProductFeatureViewController.m
//  App42
//
//  Created by Purnima Singh on 29/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42ProductFeatureViewController.h"
#import "UIColor+UIColor_HexValue.h"
#import "FeatureHeaderView.h"
#import "FeatureTableViewCell.h"
#import "App42CoreDataHandler.h"
#import "App42Constant.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "NSString+MD5.h"
#import "App42CommonMethods.h"
#import "App42CartViewController.h"
#import "App42ProductDataModel.h"
#import "App42RecommendationViewController.h"
#import "MBProgressHUD.h"

@interface App42ProductFeatureViewController ()
{
    int sectionTotalCount;
}
@property (nonatomic, strong) NSArray *featuresArray;
@property (nonatomic, strong) NSArray *benefitsArray;
@property (nonatomic, strong) NSMutableArray *getRecommendedArray;

@end

@implementation App42ProductFeatureViewController

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFir];
}

-(void)sizeHeaderToFir {
    UIView *headerView = [self.featureTableView tableHeaderView];
    [headerView layoutSubviews];
    [headerView layoutIfNeeded];
    
    CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    
    self.featureTableView.tableHeaderView = headerView;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [App42CommonMethods setCloudAPICredentials];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.featureTableView.delegate = self;
    self.featureTableView.dataSource = self;

    self.title = self.modelData.name;

    sectionTotalCount = 0;
    self.featuresArray = self.modelData.features;
    self.benefitsArray = self.modelData.benefits;
    
    NSLog(@"features count: %lu features array:%@", (unsigned long)self.featuresArray.count, self.featuresArray);
    NSLog(@"benefits count: %lu benefits array:%@", (unsigned long)self.benefitsArray.count, self.benefitsArray);

    if (self.featuresArray.count > 0) {
        sectionTotalCount = sectionTotalCount + 1;
    }
    
    if (self.benefitsArray.count > 0) {
        sectionTotalCount = sectionTotalCount + 1;
    }
    NSLog(@"section total count: %d", sectionTotalCount);
    
//    App42FeatureDataModel *featureModel = benefitsArray[0];
//    self.basicCoverName.text = featureModel.name;
//    self.basicCoverDescription.text = featureModel.theDescription;
    
    self.buynowButton.layer.borderWidth = 1.5;
    self.buynowButton.layer.borderColor = [UIColor colorFromHexString:@"#0433FF"].CGColor;
    self.buynowButton.layer.masksToBounds = true;
    self.buynowButton.layer.cornerRadius = 10.0;
    
    self.addtocartButton.layer.masksToBounds = true;
    self.addtocartButton.layer.cornerRadius = 10.0;
    
    FeatureHeaderView *headerView = (FeatureHeaderView *)[self.featureTableView tableHeaderView];
    headerView.titleLabel.text = self.modelData.name;
    headerView.descriptionLabel.text = self.modelData.theDescription;
    headerView.totalAmountLabel.text = self.modelData.amount;
    
    self.featureTableView.tableFooterView = [[UIView alloc] init];
    self.featureTableView.rowHeight = UITableViewAutomaticDimension;
    self.featureTableView.estimatedRowHeight = 200;

    [self getRecommendedItemList:[App42API getLoggedInUser]];
    
    self.recommendedProductLabel.hidden = true;
    self.recommendedProductLabel.userInteractionEnabled = true;
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addRecommendView)];
    labelTap.numberOfTapsRequired = 1;
    [self.recommendedProductLabel addGestureRecognizer:labelTap];
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
    if ([[segue identifier] isEqualToString:@"addtocartSegue"]) {
        App42CartViewController *cartVC = [segue destinationViewController];
        cartVC.isFromFeature = true;
    }
}


- (IBAction)addtocartBtnClick:(UIButton *)sender {
    
    if ([[sender.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"ADD TO CART"]) {
//        [sender setTitle:@"  ADDED TO CART" forState:UIControlStateNormal];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];  //Activity Indicator loading
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            BOOL isDataSave = [App42CoreDataHandler saveDataTotheEntity:kAddToCartEntityName modelData:self.modelData];
            if (isDataSave) {
                NSLog(@"add to cart data saved successfully");
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES]; //hide that after your Dela Loading finished fromDatabase
            });
        });

        
    }
    /*else {
        [sender setTitle:@"  ADD TO CART" forState:UIControlStateNormal];
        
        BOOL isDataDelete = [App42CoreDataHandler deleteData:kAddToCartEntityName index:self.indexValue];
        if (isDataDelete) {
            NSLog(@"add to cart data delete successfully");
        }
    }*/
}

- (IBAction)buynoeBtnClick:(UIButton *)sender {
    BOOL isDataSave = [App42CoreDataHandler saveDataTotheEntity:kAddToCartEntityName modelData:self.modelData];
    if (isDataSave) {
        NSLog(@"add to cart data saved successfully");
    }
    
    
    [self performSegueWithIdentifier:@"addtocartSegue" sender:self];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.benefitsArray.count > 0) {
        return sectionTotalCount;
    }
    else {
        return 1;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.benefitsArray.count > 0) {
        if (section == 0) {
            return @"Basic Covers";
        }
        else {
            return @"Product Features";
        }
    }
    else {
        return @"Product Features";
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeatureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"featureCell" forIndexPath:indexPath];
    if (self.benefitsArray.count > 0) {
        if (indexPath.section == 0) {
            App42FeatureDataModel *featureModel = self.benefitsArray[indexPath.row];
            cell.titleLabel.text = featureModel.name;
            cell.descriptionLabel.text = featureModel.theDescription;
        }
        else {
            App42FeatureDataModel *featureModel = self.featuresArray[indexPath.row];
            cell.titleLabel.text = featureModel.name;
            cell.descriptionLabel.text = featureModel.theDescription;
        }
    }
    else {
        App42FeatureDataModel *featureModel = self.featuresArray[indexPath.row];
        cell.titleLabel.text = featureModel.name;
        cell.descriptionLabel.text = featureModel.theDescription;
    }
    
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.benefitsArray.count > 0) {
        if (section == 0) {
            return [self.benefitsArray count];
        }
        else {
            return [self.featuresArray count];
        }
    }
    else {
        return [self.featuresArray count];
    }
}

-(void)getRecommendedItemList:(NSString *)userId {
    
    NSLog(@"all product array: %@", self.allProductarray);
    
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
                
                for (App42ProductDataModel *productModel in self.allProductarray) {
                    NSArray *modelArray = productModel.models;
                    for (App42ModelDataModel *modelData in modelArray) {
                        if ([recommendedItem.item isEqualToString:[NSString stringWithFormat:@"%d", modelData.modelID]]) {
                            [self.getRecommendedArray addObject:modelData];
                        }
                    }
                }
            }
            
            NSLog(@"getRecommendedArray: %@", self.getRecommendedArray);
            
            if (self.getRecommendedArray != nil && self.getRecommendedArray.count > 0) {
                self.recommendedProductLabel.hidden = NO;
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
    App42RecommendationViewController *recommendVC = [self.storyboard instantiateViewControllerWithIdentifier:@"App42RecommendationViewController"];
//    recommendVC.cardColorCode = self.productData.cardColor;
    recommendVC.recommendedArray = [self.getRecommendedArray mutableCopy];
    recommendVC.allproductArray = [self.allProductarray mutableCopy];
    [self addChildViewController:recommendVC];
    [self.view addSubview:recommendVC.view];
    [recommendVC didMoveToParentViewController:self];
    
}

@end
