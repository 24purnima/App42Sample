//
//  App42RecommendationViewController.m
//  App42
//
//  Created by Purnima Singh on 10/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42RecommendationViewController.h"
#import "RecommenderCollectionViewCell.h"
#import "App42ModelDataModel.h"
#import "UIImageView+WebCache.h"
#import "App42CommonMethods.h"
#import "App42CoreDataHandler.h"
#import "App42Constant.h"
#import "App42ProductFeatureViewController.h"

#import "UIColor+UIColor_HexValue.h"
@interface App42RecommendationViewController ()
{
    App42ModelDataModel *dataModel;
}
@end

@implementation App42RecommendationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataModel = [[App42ModelDataModel alloc] init];
    
    self.recommendCollectionView.delegate = self;
    self.recommendCollectionView.dataSource = self;
    self.pageControl.numberOfPages = [self.recommendedArray count];
    self.pageControl.currentPage = 0;
    self.view.frame = CGRectMake(0, self.view.frame.size.height - 450, self.view.frame.size.width, 330);
    
//    self.view.backgroundColor = [UIColor colorFromHexString:self.cardColorCode];
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
    
    if ([segue.identifier isEqualToString:@"productRecommendFeature"]) {
        App42ProductFeatureViewController *featureVC = segue.destinationViewController;
        featureVC.modelData = dataModel;
        featureVC.allProductarray = self.allproductArray;
    }
    
}


- (IBAction)cloaseBtnClick:(id)sender {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)valueChanged:(id)sender {
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommenderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendCell" forIndexPath:indexPath];
    App42ModelDataModel *modelData = [self.recommendedArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = modelData.name;
    cell.descriptionLabel.text = modelData.theDescription;
    [cell.thumbImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", modelData.iconURL]]];
    
    
    [cell.addtocartButton addTarget:self action:@selector(addtocartButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.wishlistButton addTarget:self action:@selector(wishlistButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.recommendedArray count];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    dataModel = self.recommendedArray[indexPath.row];
    [self performSegueWithIdentifier:@"productRecommendFeature" sender:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.recommendCollectionView.frame.size.width;
    float currentPage = self.recommendCollectionView.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
    {
        self.pageControl.currentPage = currentPage + 1;
    }
    else
    {
        self.pageControl.currentPage = currentPage;
    }
    
    NSLog(@"Page Number : %ld", (long)self.pageControl.currentPage);
}


-(void)addtocartButtonClick:(UIButton *)sender {
    NSLog(@"add to cart button click");
    
    RecommenderCollectionViewCell *collectionView = (RecommenderCollectionViewCell *)sender.superview.superview;
    NSIndexPath* pathOfTheCell = [self.recommendCollectionView indexPathForCell:collectionView];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    App42ModelDataModel *saveWishlistData = self.recommendedArray[rowOfTheCell];
    
    if ([[sender.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"ADD TO CART"]) {
        BOOL isDataSave = [App42CoreDataHandler saveDataTotheEntity:kAddToCartEntityName modelData:saveWishlistData];
        if (isDataSave) {
            NSLog(@"add to cart data saved successfully");
        }
    }
}

-(void)wishlistButtonClick:(UIButton *)sender {
    NSLog(@"wishlist button click");
    
    RecommenderCollectionViewCell *collectionView = (RecommenderCollectionViewCell *)sender.superview.superview;
    NSIndexPath* pathOfTheCell = [self.recommendCollectionView indexPathForCell:collectionView];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    App42ModelDataModel *saveWishlistData = self.recommendedArray[rowOfTheCell];
    
    
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
    }
}

@end
