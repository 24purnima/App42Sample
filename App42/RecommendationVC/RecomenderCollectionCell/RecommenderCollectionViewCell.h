//
//  RecommenderCollectionViewCell.h
//  App42
//
//  Created by Purnima Singh on 20/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommenderCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *thumbImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *addtocartButton;
@property (strong, nonatomic) IBOutlet UIButton *wishlistButton;

@end
