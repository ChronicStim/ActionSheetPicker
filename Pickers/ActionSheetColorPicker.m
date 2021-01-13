//
//Copyright (c) 2011, Tim Cinel
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//* Redistributions of source code must retain the above copyright
//notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright
//notice, this list of conditions and the following disclaimer in the
//documentation and/or other materials provided with the distribution.
//* Neither the name of the <organization> nor the
//names of its contributors may be used to endorse or promote products
//derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//åLOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "ActionSheetColorPicker.h"
#import "AbstractActionSheetPicker.h"
#import "ColorCollection.h"
#import "ColorObject.h"

@interface ActionSheetColorPicker()
@property (nonatomic,retain) ColorCollection *colorCollection;
@property (nonatomic,retain) NSString *selectedKey;
@property (nonatomic,assign) ColorSortMode colorSortMode;
@end

@implementation ActionSheetColorPicker
@synthesize colorCollection = _colorCollection;
@synthesize selectedKey = _selectedKey;
@synthesize colorSortMode = _colorSortMode;
@synthesize onActionSheetDone = _onActionSheetDone;
@synthesize onActionSheetCancel = _onActionSheetCancel;

+ (id)showColorPickerWithTitle:(NSString *)title sortMode:(int)colorSortMode initialKey:(NSString *)key doneBlock:(ActionColorDoneBlock)doneBlock cancelBlock:(ActionColorCancelBlock)cancelBlockOrNil origin:(id)origin;
{
    ActionSheetColorPicker * picker = [[ActionSheetColorPicker alloc] initColorPickerWithTitle:title sortMode:colorSortMode initialKey:key doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initColorPickerWithTitle:(NSString *)title sortMode:(int)colorSortMode initialKey:(NSString *)key doneBlock:(ActionColorDoneBlock)doneBlock cancelBlock:(ActionColorCancelBlock)cancelBlockOrNil origin:(id)origin;
{
    self = [self initColorPickerWithTitle:title sortMode:colorSortMode initialKey:key target:nil sucessAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlockOrNil;
    }
    return self;
}

+ (id)showColorPickerWithTitle:(NSString *)title sortMode:(int)colorSortMode initialKey:(NSString *)key target:(id)target sucessAction:(SEL)sucessAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;
{
    ActionSheetColorPicker *picker = [[ActionSheetColorPicker alloc] initColorPickerWithTitle:title sortMode:colorSortMode initialKey:key target:target sucessAction:sucessAction cancelAction:cancelActionOrNil origin:origin];
    [picker addCustomButtonWithTitle:@"Name" value:[NSNumber numberWithInt:CSM_ColorName]];
    [picker addCustomButtonWithTitle:@"Hue" value:[NSNumber numberWithInt:CSM_Hue]];
    [picker setHideCancel:YES];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initColorPickerWithTitle:(NSString *)title sortMode:(int)colorSortMode initialKey:(NSString *)key target:(id)target sucessAction:(SEL)sucessAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;
{
    self = [self initWithTarget:target successAction:sucessAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        self.colorCollection = [[ColorCollection alloc] initColorCollection];
        self.colorSortMode = colorSortMode;
        self.selectedKey = key;
        NSInteger selectedIndex = [self.colorCollection indexForKey:key usingSortMode:colorSortMode];
        [(UIPickerView *)self.pickerView selectRow:selectedIndex inComponent:0 animated:NO];
        self.title = title;
    }
    return self;
}

- (UIView *)configuredPickerView {
    if (!self.colorCollection)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *stringPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    stringPicker.showsSelectionIndicator = YES;
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    
    [self displayCurrentIndexWithinPickerview];
    
    return stringPicker;
}

-(void)displayCurrentIndexWithinPickerview;
{
    NSInteger currentIndex = [self.colorCollection indexForKey:self.selectedKey usingSortMode:self.colorSortMode];
    if (currentIndex >= 0) {
        [(UIPickerView *)self.pickerView selectRow:currentIndex inComponent:0 animated:NO];
    }
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)sucessAction origin:(id)origin {    
    if (self.onActionSheetDone) {
        _onActionSheetDone(self, self.selectedKey, [self.colorCollection colorObjectForKey:self.selectedKey]);
        return;
    }
    else if (target && [target respondsToSelector:sucessAction]) {
        [target performSelector:sucessAction withObject:self.selectedKey withObject:origin];
        return;
    }
//    NSLog(@"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), (char *)sucessAction);
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        _onActionSheetCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction])
        [target performSelector:cancelAction withObject:origin];
}

#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    ColorObject *colorObject = [self.colorCollection colorObjectAtIndex:row withSortMode:self.colorSortMode];
    self.selectedKey = [colorObject colorKeyString];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.colorCollection numberOfColorObjects];
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return [(ColorObject *)[self.colorCollection colorObjectAtIndex:row withSortMode:self.colorSortMode] colorName];
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGSize viewSize = [pickerView rowSizeForComponent:component];
    CGRect viewRect = CGRectMake(0, 0, viewSize.width, viewSize.height);
    
    UIView *rowView = [[UIView alloc] initWithFrame:viewRect];
    CGFloat labelInset = 5.0f;
    CGRect labelRect = CGRectMake(labelInset, 0.0f, (viewRect.size.width - (2*labelInset)), viewRect.size.height);
    UILabel *colorLabel = [[UILabel alloc] initWithFrame:labelRect];
    [colorLabel setBackgroundColor:[UIColor clearColor]];
    [colorLabel setFont:[UIFont cptBoldFont]];
    [colorLabel setTextColor:[UIColor whiteColor]];
    [colorLabel setAdjustsFontSizeToFitWidth:YES];
    
    ColorObject *colorObject = [self.colorCollection colorObjectAtIndex:row withSortMode:self.colorSortMode];
    
    [colorLabel setText:[colorObject colorName]];
    [rowView addSubview:colorLabel];
    
    UIColor *bkgdColor = [colorObject uiColorDefinition];
    [rowView setBackgroundColor:bkgdColor];
    
    return rowView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width - 30;
}

- (void)customButtonPressed:(id)sender {
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    NSInteger index = button.tag;
    NSAssert((index >= 0 && index < self.customButtons.count), @"Bad custom button tag: %ld, custom button count: %lu", (long)index, (unsigned long)self.customButtons.count);    
//    NSAssert([self.pickerView respondsToSelector:@selector(setDate:animated:)], @"Bad pickerView for ActionSheetDatePicker, doesn't respond to setDate:animated:");
    NSDictionary *buttonDetails = [self.customButtons objectAtIndex:index];
    ColorSortMode newColorSortMode = [[buttonDetails objectForKey:@"buttonValue"] intValue];
    self.colorSortMode = newColorSortMode;
    [self displayCurrentIndexWithinPickerview];

}

#pragma mark - Block setters

// NOTE: Sometimes see crashes when relying on just the copy property. Using Block_copy ensures correct behavior

- (void)setOnActionSheetDone:(ActionColorDoneBlock)onActionSheetDone {
    if (_onActionSheetDone) {
        _onActionSheetDone = nil;
    }
    _onActionSheetDone = [onActionSheetDone copy];
}

- (void)setOnActionSheetCancel:(ActionColorCancelBlock)onActionSheetCancel {
    if (_onActionSheetCancel) {
        _onActionSheetCancel = nil;
    }
    _onActionSheetCancel = [onActionSheetCancel copy];
}

@end
