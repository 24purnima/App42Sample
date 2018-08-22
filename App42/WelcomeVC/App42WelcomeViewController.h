//
//  App42WelcomeViewController.h
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface App42WelcomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *patternImageView;

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue;

@end
