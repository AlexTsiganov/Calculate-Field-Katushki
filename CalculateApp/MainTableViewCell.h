//
//  MainTableViewCell.h
//  CalculateApp
//
//  Created by Alex Tsiganov on 30.12.14.
//  Copyright (c) 2014 Alex Tsiganov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawGraphCellData.h"

@interface MainTableViewCell : UITableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>
{
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UIView *drawContainer;
    __weak IBOutlet UIPickerView *pickerView;
    __weak IBOutlet UIButton *btnPicker;
    
    __weak IBOutlet NSLayoutConstraint *lcDrawContainerHeight;
    __weak IBOutlet NSLayoutConstraint *lcTopPickerMargin;
}
@property(nonatomic, strong) DrawGraphCellData *data;
@end
