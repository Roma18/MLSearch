//
//  ItemViewController.h
//  MLSearch
//
//  Created by Julian Centurion on 5/13/15.
//  Copyright (c) 2015 Julian Centurion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UIViewController <UIAlertViewDelegate>
-(void) ShowItem:(NSString *) itemID;
@property (weak, nonatomic) IBOutlet UIImageView *imagenViewSpace;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end
