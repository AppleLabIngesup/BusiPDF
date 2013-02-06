//
//  ALMasterViewController.h
//  BusiPDF
//
//  Created by Mathieu Amiot on 06/02/13.
//  Copyright (c) 2013 Ingesup. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALDetailViewController;

@interface ALMasterViewController : UITableViewController

@property (strong, nonatomic) ALDetailViewController *detailViewController;

@end
