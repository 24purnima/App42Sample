//
//  App42MenuViewController.m
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42MenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "UIColor+UIColor_HexValue.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "App42CoreDataHandler.h"
#import "App42Constant.h"
#import "App42WelcomeViewController.h"
#import "AppDelegate.h"

@interface App42MenuViewController ()
{
    int wishlistCount;
    int cartCount;
}
@end

@implementation App42MenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.slideOutAnimationEnabled = YES;
    
    return [super initWithCoder:aDecoder];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateBadgeNumber];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"menuu");
    
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *userFetchRequest = [[NSFetchRequest alloc] initWithEntityName:kLoginEntityName];
    NSArray *userArray = [[context executeFetchRequest:userFetchRequest error:nil] mutableCopy];
    NSLog(@"userArray: %@", userArray);
    
    for (NSManagedObject *obj in userArray) {
        self.userImageView.image = [UIImage imageNamed:@"user_icon"];
        self.userNameLabel.text = [obj valueForKey:kUserNameAttribute];
    }
    
    self.pointsCount.text = [NSString stringWithFormat:@"0 Points"];
    
    _menus = [NSArray arrayWithObjects:@"Products", @"Cart", @"Chat", @"Wishlist", @"Customer Support", @"Sign Out", nil];
    _menusImages = [NSArray arrayWithObjects:@"products", @"addtocart", @"chat", @"unlike", @"customersupport", @"signout", nil];

    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    
    self.menuTableView.tableFooterView = [[UIView alloc] init];
    
    self.profileBackView.userInteractionEnabled = true;
    UITapGestureRecognizer *profileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileViewTap)];
    profileTap.numberOfTapsRequired = 1;
    [self.profileBackView addGestureRecognizer:profileTap];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeNumber) name:@"updateBadgeNumber" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setWishlistCount:) name:@"setWishlistCount" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCartCount:) name:@"setCartCount" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menus.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    
    if ([_menus[indexPath.row] isEqualToString:@"Cart"] || [_menus[indexPath.row] isEqualToString:@"Wishlist"]) {
        if (wishlistCount > 0 && [_menus[indexPath.row] isEqualToString:@"Wishlist"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@  [%d]", _menus[indexPath.row], wishlistCount];
        }
        else if (cartCount > 0 && [_menus[indexPath.row] isEqualToString:@"Cart"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@  [%d]", _menus[indexPath.row], cartCount];
        }
        else {
            cell.textLabel.text = _menus[indexPath.row];
        }
    }
    else {
        cell.textLabel.text = _menus[indexPath.row];
    }
    
    cell.imageView.image = [UIImage imageNamed:_menusImages[indexPath.row]];
    cell.textLabel.textColor = [UIColor colorFromHexString:@"#0433FF"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NSLog(@"cell taped");
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    UIViewController *vc ;
    BOOL isDataDelete;
    
    
    if ([_menus[indexPath.row] isEqualToString:@"Products"]) {
        [self.menuTableView deselectRowAtIndexPath:[self.menuTableView indexPathForSelectedRow] animated:YES];
        [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
        return;
    }
    else if ([_menus[indexPath.row] isEqualToString:@"Cart"]) {
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"App42CartViewController"];
    }
    else if ([_menus[indexPath.row] isEqualToString:@"Chat"]) {
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"App42ChatViewController"];
    }
    else if ([_menus[indexPath.row] isEqualToString:@"Wishlist"]) {
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"App42WishlistViewController"];
    }
    else if ([_menus[indexPath.row] isEqualToString:@"Customer Support"]) {
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"App42CustomerSupportViewController"];
    }
    else if ([_menus[indexPath.row] isEqualToString:@"Sign Out"]) {
        isDataDelete = [App42CoreDataHandler deleteAllSavedDataFromEntity:kLoginEntityName];
        
        if (isDataDelete) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseHomePage" object:nil];
        }
        [self.menuTableView deselectRowAtIndexPath:[self.menuTableView indexPathForSelectedRow] animated:YES];
        [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
        
        return;
    }
    
    /*switch (indexPath.row)
    {
        case 0:
            [self.menuTableView deselectRowAtIndexPath:[self.menuTableView indexPathForSelectedRow] animated:YES];
            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
            return;
            break;
            
        case 1:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"App42CartViewController"];
            break;
            
        case 2:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"App42ChatViewController"];
            break;
            
        case 3:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"App42WishlistViewController"];
            break;
            
        case 4:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"App42CustomerSupportViewController"];
            break;
            
        case 5://logout not working
            
            isDataDelete = [App42CoreDataHandler deleteAllSavedDataFromEntity:kLoginEntityName];
            
            if (isDataDelete) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseHomePage" object:nil];
            }
            [self.menuTableView deselectRowAtIndexPath:[self.menuTableView indexPathForSelectedRow] animated:YES];
            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
            
            return;
            break;
    }*/
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(void)profileViewTap {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"App42ProfileViewController"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
    
}


-(void)updateBadgeNumber{
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *loyaltyRequest = [[NSFetchRequest alloc] initWithEntityName:kLoyaltyEntityName];
    NSArray *loyalArray = [[context executeFetchRequest:loyaltyRequest error:nil] mutableCopy];
    for (NSManagedObject *loyalObj in loyalArray) {
        if ([[loyalObj valueForKey:kUserNameAttribute] isEqualToString:[App42API getLoggedInUser]]) {
            self.pointsCount.text = [NSString stringWithFormat:@"%@ Points", [loyalObj valueForKey:kTotalPointsAttribute]];
        }
    }
    
    NSLog (@"Total points is! ");
}

-(void)setWishlistCount:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    wishlistCount = [[info objectForKey:@"count"] intValue];
    [self.menuTableView reloadData];
}

-(void)setCartCount:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    cartCount = [[info objectForKey:@"count"] intValue];
    [self.menuTableView reloadData];
}
@end
