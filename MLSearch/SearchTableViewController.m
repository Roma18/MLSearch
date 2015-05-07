//
//  SearchTableViewController.m
//  MLSearch
//
//  Created by Julian Centurion on 5/7/15.
//  Copyright (c) 2015 Julian Centurion. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SearchResultsTableViewController.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ClickOnSearchButton:(id)sender {
    NSLog(@"ClickOnSearchButton");
    SearchResultsTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResult"];
    
    [self.navigationController pushViewController:viewController animated:YES ];
       
    [viewController ReceiveSearchString:self.searchStringTextField.text];
    
}
@end
