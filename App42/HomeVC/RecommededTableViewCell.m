//
//  RecommededTableViewCell.m
//  App42
//
//  Created by Purnima Singh on 07/08/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "RecommededTableViewCell.h"
#import "App42ModelDataModel.h"
#import "RecommenderCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "App42CommonMethods.h"
#import "App42CoreDataHandler.h"
#import "App42Constant.h"
#import "MBProgressHUD.h"
#import "App42ProductFeatureViewController.h"

@implementation RecommededTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.recommenderCollectionView.delegate = self;
    self.recommenderCollectionView.dataSource = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.recommendArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommenderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendCell" forIndexPath:indexPath];
    
    App42ModelDataModel *modelData = [self.recommendArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = modelData.name;
    cell.descriptionLabel.text = modelData.theDescription;
    [cell.thumbImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", modelData.iconURL]]];
    
    
    [cell.addtocartButton addTarget:self action:@selector(collectionAddtocartButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.wishlistButton addTarget:self action:@selector(collectionWishlistButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    App42ModelDataModel *dataModel = self.recommendArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(openFeaturePage:)]) {
        [self.delegate openFeaturePage:dataModel];
    }
//
//    App42ProductFeatureViewController *featureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"App42ProductFeatureViewController"];
//    [self.navigationController pushViewController:featureVC animated:YES];
}


-(void)collectionWishlistButtonClick:(UIButton *)sender {
    
    RecommenderCollectionViewCell* tableView = (RecommenderCollectionViewCell *)sender.superview.superview;
    NSIndexPath* pathOfTheCell = [self.recommenderCollectionView indexPathForCell:tableView];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    NSLog(@"row cell: %ld", rowOfTheCell);
    
    App42ModelDataModel *saveWishlistData = self.recommendArray[rowOfTheCell];
     
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
    }
}

-(void)collectionAddtocartButtonClick:(UIButton *)sender {
    
    RecommenderCollectionViewCell* tableView = (RecommenderCollectionViewCell *)sender.superview.superview;
    NSIndexPath* pathOfTheCell = [self.recommenderCollectionView indexPathForCell:tableView];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    NSLog(@"row cell: %ld", rowOfTheCell);
    
    App42ModelDataModel *saveWishlistData = self.recommendArray[rowOfTheCell];
     
     if ([[sender.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"ADD TO CART"]) {
     
         [MBProgressHUD showHUDAddedTo:self animated:YES];  //Activity Indicator loading
     
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
             BOOL isDataSave = [App42CoreDataHandler saveDataTotheEntity:kAddToCartEntityName modelData:saveWishlistData];
             if (isDataSave) {
                 NSLog(@"add to cart data saved successfully");
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self animated:YES]; //hide that after your Dela Loading finished fromDatabase
             });
         });
    }
}


-(void)setCollectionViewData:(NSMutableArray *)recommendArray allProuctArray:(NSMutableArray *)productArray {
    self.recommendArray = [recommendArray mutableCopy];
    self.allproductArray = [productArray copy];
    self.recommedPageControl.numberOfPages = [self.recommendArray count];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.recommenderCollectionView.frame.size.width;
    float currentPage = self.recommenderCollectionView.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
    {
        self.recommedPageControl.currentPage = currentPage + 1;
    }
    else
    {
        self.recommedPageControl.currentPage = currentPage;
    }
    
    NSLog(@"Page Number : %ld", (long)self.recommedPageControl.currentPage);
}

@end
