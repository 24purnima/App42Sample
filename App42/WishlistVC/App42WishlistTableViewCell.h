//
//  App42WishlistTableViewCell.h
//  App42
//
//  Created by Purnima Singh on 09/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface App42WishlistTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (strong, nonatomic) IBOutlet UIButton *removeButton;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@end
