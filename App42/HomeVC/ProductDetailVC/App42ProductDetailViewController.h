//
//  App42ProductDetailViewController.h
//  App42
//
//  Created by Purnima Singh on 29/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App42ProductDataModel.h"


@interface App42ProductDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) App42ProductDataModel *productData;
@property (strong, nonatomic) NSMutableArray *allproductArray;
@property (strong, nonatomic) NSArray *detailArray;

@property (nonatomic, strong) NSMutableArray *searchResults;
//@property (nonatomic, assign) BOOL *shouldShowSearchResults;


@property (strong, nonatomic) IBOutlet UITableView *productDetailTable;
@property (strong, nonatomic) IBOutlet UISearchBar *searchController;

@end
