//
//  SearchFildViewController.m
//  MLSearch
//
//  Created by Julian Centurion on 5/11/15.
//  Copyright (c) 2015 Julian Centurion. All rights reserved.
//

#import "SearchFildViewController.h"
#import "SearchResultsTableViewController.h"

@interface SearchFildViewController ()
@end

@implementation SearchFildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    //self.searchHistoryArray = [NSMutableArray new];
    self.searchHistoryArray =  [[[[NSUserDefaults standardUserDefaults] arrayForKey:@"searchHistory"] mutableCopy] init];

    [self.searchTableView reloadData];
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    [super loadView];
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    //tableView.delegate = self;
    //tableView.dataSource = self;
    [tableView reloadData];
    
    //self.view = tableView;
    self.searchTableView = tableView;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.searchTableView reloadData];
}

-(void) ReloadTableData{
    [self.searchTableView reloadData];
}

-(void)hideKeyBoard {
    [self.searchStringTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) ChangeViewAndSearch{
    [self SaveInTextSringInHistory];
    SearchResultsTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResult"];
    [self.navigationController pushViewController:viewController animated:YES ];
    [viewController ReceiveSearchString:self.searchStringTextField.text];
}

- (void) SaveInTextSringInHistory{
    //self.searchHistoryArray = [NSMutableArray new];
    NSString *stringToSave = self.searchStringTextField.text;
    [self.searchHistoryArray addObject:stringToSave];
    NSLog(@"string to save: %@", stringToSave);
    NSLog(@"string in [0]: %@", [self.searchHistoryArray objectAtIndex:0]);
    
    [[NSUserDefaults standardUserDefaults] setObject:self.searchHistoryArray forKey:@"searchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)ClickOnSearchButton:(id)sender {
    [self ChangeViewAndSearch];
}

- (IBAction)dismissKeyboard:(id)sender;
{
    [self.searchStringTextField becomeFirstResponder];
    [self.searchStringTextField resignFirstResponder];
    [self ChangeViewAndSearch];
}

#pragma Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [self.searchHistoryArray count];
    //return (NSInteger) 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"SearchHistorialCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    cell.textLabel.text = (self.searchHistoryArray) [indexPath.row];
    //cell.textLabel.text = @"test";
    return cell;
}


@end
