//
//  FeatureHeaderView.m
//  App42
//
//  Created by Purnima Singh on 02/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "FeatureHeaderView.h"

@implementation FeatureHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.bounds.size.width;
    
}
@end
