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
@property (nonatomic, retain) NSString *colorName;
@property (nonatomic, retain) UIColor *uiColorDefinition;
@property (nonatomic, retain) NSNumber *hueValue;
@property (nonatomic, retain) NSString *hexString;
@property (nonatomic, retain) NSString *colorKeyString;
@property (nonatomic, retain) NSNumber *sortIndex;

-(id)initWithHexString:(NSString *)aHexString forColorName:(NSString *)aColorName forColorKey:(NSString *)aColorKey withSortIndex:(NSInteger)sortIndex;
-(UIColor *)uiColorForHexString:(NSString *)hexColor;


@end
