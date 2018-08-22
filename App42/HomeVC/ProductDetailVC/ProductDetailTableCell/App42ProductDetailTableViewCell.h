//
//  App42ProductDetailTableViewCell.h
//  App42
//
//  Created by Purnima Singh on 29/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface App42ProductDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIButton *addToCartButton;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *wishlistButton;
@end
