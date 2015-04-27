//
//  MainTableViewCell.m
//  CalculateApp
//
//  Created by Alex Tsiganov on 30.12.14.
//  Copyright (c) 2014 Alex Tsiganov. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

-(void) layoutSubviews
{
    [super layoutSubviews];
    float f = CGRectGetWidth([UIScreen mainScreen].applicationFrame);
    lcDrawContainerHeight.constant = f;
}

-(void) setData:(DrawGraphCellData *)data
{
    _data = data;
    [self updatePickerState];
}

-(void) showPicker
{
    _data.isPickerShow = YES;
    pickerView.hidden = NO;
    lcTopPickerMargin.constant = 208;
}

-(void) hidePicker
{
    _data.isPickerShow = YES;
    lcTopPickerMargin.constant = 0;
    pickerView.hidden = YES;
}

-(void) updatePickerState
{
    if (_data.isPickerShow)
    {
        [self showPicker];
    }
    else
        [self hidePicker];
}

#pragma mark - Buttons click

-(IBAction) onPickerButtonClick
{
    _data.isPickerShow = !_data.isPickerShow;
    [self updatePickerState];
}

@end
