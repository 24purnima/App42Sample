//
//  ProductDetailHeaderView.h
//  App42
//
//  Created by Purnima Singh on 10/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
