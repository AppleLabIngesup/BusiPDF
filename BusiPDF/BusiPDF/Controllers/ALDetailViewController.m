//
//  ALDetailViewController.m
//  BusiPDF
//
//  Created by Mathieu Amiot on 06/02/13.
//  Copyright (c) 2013 Ingesup. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ALDetailViewController.h"

@interface ALDetailViewController ()
@property(strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;
@end

@implementation ALDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;

        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem)
    {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)spinLayer:(CALayer *)inLayer duration:(CFTimeInterval)inDuration
        direction:(int)direction
{
    CABasicAnimation* rotationAnimation;

    // Rotate about the z axis
    rotationAnimation =
            [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];

    // Rotate 360 degress, in direction specified
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * direction];

    // Perform the rotation over this many seconds
    rotationAnimation.duration = inDuration;

    // Set the pacing of the animation
    rotationAnimation.timingFunction =
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    // Add animation to the layer and make it so
    [inLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];

    self.v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finance"]];
    [self.view addSubview:self.v];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rotate) userInfo:nil repeats:YES];
}

- (void)rotate
{
    [self spinLayer:self.v.layer duration:1 direction:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
