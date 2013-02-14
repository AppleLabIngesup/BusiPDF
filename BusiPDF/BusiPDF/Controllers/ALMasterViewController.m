//
//  ALMasterViewController.m
//  BusiPDF
//
//  Created by Mathieu Amiot on 06/02/13.
//  Copyright (c) 2013 Ingesup. All rights reserved.
//

#import "ALMasterViewController.h"
#import "ALDetailViewController.h"

@interface ALMasterViewController ()
{
    NSMutableArray *_objects;
    NSString *_documentsPath;
}
@end

@implementation ALMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"FileList", @"File Manager");
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;

    // Add existing files from bundle/Documents
    _documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSError *error = nil;
    NSArray *array = [[NSFileManager defaultManager]
            contentsOfDirectoryAtPath:_documentsPath
                                error:&error];
    NSLog(@"%@", array);

    if (!array) return;
    if (!_objects)
        _objects = [[NSMutableArray alloc] init];
    for (NSString *s in array)
    {
        if ([[s substringToIndex:1] isEqualToString:@"."]) continue;

        [_objects addObject:[@{
                @"url" : [_documentsPath stringByAppendingPathComponent:s],
                @"text" : [s lastPathComponent],
                @"document" : [NSNull null]
        } mutableCopy]];
    }
    NSLog(@"%@", _objects);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects)
    {
        _objects = [[NSMutableArray alloc] init];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AddPDF", @"Add new PDF from URL...") message:@"Insert URL for your PDF" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSDictionary *object = _objects[(NSUInteger) indexPath.row];
    cell.textLabel.text = object[@"text"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[_documentsPath stringByAppendingPathComponent:_objects[(NSUInteger) indexPath.row][@"text"]] error:NULL];
        [_objects removeObjectAtIndex:(NSUInteger) indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *object = _objects[(NSUInteger) indexPath.row];
    [self openReaderDocument:object];

}

- (void)openReaderDocument:(NSMutableDictionary *)documentDictionary
{
    // If handled from external app
    if ([_objects indexOfObject:documentDictionary] == NSNotFound)
        [_objects addObject:documentDictionary];

    ReaderDocument *readerDocument;
    ReaderDocument *docDict = documentDictionary[@"document"];
    if (!docDict || [docDict isEqual:[NSNull null]])
    {
        readerDocument = [[ReaderDocument alloc] initWithFilePath:[_documentsPath stringByAppendingPathComponent:documentDictionary[@"text"]] password:nil];
        [documentDictionary setValue:readerDocument forKey:@"document"];
    }
    else
        readerDocument = docDict;

    NSLog(@"%@", _objects);
    self.detailViewController.detailItem = readerDocument;
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0)
    {
        NSString *url = [alertView textFieldAtIndex:0].text;
        NSString *fileName = [url lastPathComponent];
        NSData *fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];

        [fileData writeToFile:[_documentsPath stringByAppendingPathComponent:fileName] atomically:YES];
        NSDictionary *obj = [@{@"url" : url, @"text" : fileName, @"document": [[ReaderDocument alloc] initWithFilePath:[_documentsPath stringByAppendingPathComponent:fileName] password:nil]} mutableCopy];
        [_objects insertObject:obj atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
