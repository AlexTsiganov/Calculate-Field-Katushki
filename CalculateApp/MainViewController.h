//
//  MainViewController.h
//  CalculateApp
//
//  Created by Alex Tsiganov on 30.12.14.
//  Copyright (c) 2014 Alex Tsiganov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UIView *tableViewHeader;
    __weak IBOutlet UITableView *tableView;
}
@end
