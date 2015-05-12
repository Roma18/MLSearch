//
//  SearchFildViewController.h
//  MLSearch
//
//  Created by Julian Centurion on 5/11/15.
//  Copyright (c) 2015 Julian Centurion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFildViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (IBAction)ClickOnSearchButton:(id)sender;
- (void) ChangeViewAndSearch;
- (void) ReloadTableData;
- (IBAction)ClearButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (weak, nonatomic) IBOutlet UITextField *searchStringTextField;
@property (strong, nonatomic) NSMutableArray *searchHistoryArray;
@end
