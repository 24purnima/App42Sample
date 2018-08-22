//
//  App42ProductCollectionViewCell.h
//  App42
//
//  Created by Purnima Singh on 28/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface App42ProductCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
