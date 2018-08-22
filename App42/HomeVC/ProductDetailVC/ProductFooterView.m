//
//  ProductFooterView.m
//  App42
//
//  Created by Purnima Singh on 06/08/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "ProductFooterView.h"
#import "UIColor+UIColor_HexValue.h"
#import "UIImageView+WebCache.h"
#import "RecommenderCollectionViewCell.h"
#import "App42CommonMethods.h"

@interface ProductFooterView()

@property (strong, nonatomic) IBOutlet UICollectionView *recommendCollectionView;

@end

@implementation ProductFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self customInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self customInit];
    }
    return self;
}

-(void)customInit {
    self.recommendCollectionView.delegate = self;
    self.recommendCollectionView.dataSource = self;
    [self.recommendCollectionView reloadData];
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
    self.dataModel = self.recommendedArray[indexPath.row];
//    [self performSegueWithIdentifier:@"productRecommendFeature" sender:self];
}


-(void)addtocartButtonClick:(UIButton *)sender {
    NSLog(@"add to cart button click");
    
    RecommenderCollectionViewCell *collectionView = (RecommenderCollectionViewCell *)sender.superview.superview;
    NSIndexPath* pathOfTheCell = [self.recommendCollectionView indexPathForCell:collectionView];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    App42ModelDataModel *saveWishlistData = self.recommendedArray[rowOfTheCell];
    NSLog(@"rowOfTheCell: %ld", (long)rowOfTheCell);
    
//    if ([[sender.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"ADD TO CART"]) {
//        BOOL isDataSave = [App42CoreDataHandler saveDataTotheEntity:kAddToCartEntityName modelData:saveWishlistData];
//        if (isDataSave) {
//            NSLog(@"add to cart data saved successfully");
//        }
//    }
}

-(void)wishlistButtonClick:(UIButton *)sender {
    NSLog(@"wishlist button click");
    
    RecommenderCollectionViewCell *collectionView = (RecommenderCollectionViewCell *)sender.superview.superview;
    NSIndexPath* pathOfTheCell = [self.recommendCollectionView indexPathForCell:collectionView];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    NSLog(@"rowOfTheCell: %ld", (long)rowOfTheCell);

//    App42ModelDataModel *saveWishlistData = self.recommendedArray[rowOfTheCell];
//    if ([sender.currentImage isEqual:[UIImage imageNamed:@"unlike"]]) {
//        [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
//
//        [App42CommonMethods addOrUpdatePreference:saveWishlistData];
//
//        BOOL isDataSave = [App42CoreDataHandler saveDataTotheEntity:kWishlistEntityName modelData:saveWishlistData];
//        if (isDataSave) {
//            NSLog(@"wishlist data saved successfully");
//        }
//    }
//    else {
//        [sender setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
//    }
}

@end
