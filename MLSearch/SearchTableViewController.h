//
//  SearchTableViewController.h
//  MLSearch
//
//  Created by Julian Centurion on 5/7/15.
//  Copyright (c) 2015 Julian Centurion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController
- (IBAction)ClickOnSearchButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *searchStringTextField;

@end
