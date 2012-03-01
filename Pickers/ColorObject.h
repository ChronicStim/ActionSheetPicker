//
//  ColorObject.h
//  PainTracker
//
//  Created by Wendy Kutschke on 2/1/12.
//  Copyright (c) 2012 Chronic Stimulation, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorObject : NSObject
{
    NSString *_colorName;
    UIColor *_uiColorDefinition;
    NSNumber *_hueValue;
    NSString *_hexString;
    NSString *_colorKeyString;
    NSNumber *_sortIndex;
}
@property (nonatomic, strong) NSString *colorName;
@property (nonatomic, strong) UIColor *uiColorDefinition;
@property (nonatomic, strong) NSNumber *hueValue;
@property (nonatomic, strong) NSString *hexString;
@property (nonatomic, strong) NSString *colorKeyString;
@property (nonatomic, strong) NSNumber *sortIndex;

-(id)initWithHexString:(NSString *)aHexString forColorName:(NSString *)aColorName forColorKey:(NSString *)aColorKey withSortIndex:(NSInteger)sortIndex;
-(UIColor *)uiColorForHexString:(NSString *)hexColor;


@end
