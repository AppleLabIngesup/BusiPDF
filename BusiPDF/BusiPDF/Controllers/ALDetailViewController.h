//
//  ALDetailViewController.h
//  BusiPDF
//
//  Created by Mathieu Amiot on 06/02/13.
//  Copyright (c) 2013 Ingesup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"

@class ReaderViewController;

@interface ALDetailViewController : UIViewController <UISplitViewControllerDelegate, ReaderViewControllerDelegate>

@property (strong, nonatomic) ReaderDocument *detailItem;
@property (strong, nonatomic) ReaderViewController *readerController;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property(nonatomic, strong) UIImageView *v;
@end
