//
//  ColorCollection.h
//  PainTracker
//
//  Created by Wendy Kutschke on 2/1/12.
//  Copyright (c) 2012 Chronic Stimulation, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CSM_ColorName,
    CSM_Hue,
    CSM_Random,
    CSM_NoSort
} ColorSortMode;

@class ColorObject;
@interface ColorCollection : NSObject 
{
    NSDictionary *_colorDictionary;
    NSArray *_sortedKeysByColorName;
    NSArray *_sortedKeysByHue;
    NSArray *_sortedKeysRandom;
    NSArray *_unsortedKeys;
    
}
@property (nonatomic, copy) NSDictionary *colorDictionary;
@property (nonatomic, copy) NSArray *sortedKeysByColorName;
@property (nonatomic, copy) NSArray *sortedKeysByHue;
@property (nonatomic, copy) NSArray *sortedKeysRandom;
@property (nonatomic, copy) NSArray *unsortedKeys;

-(id)initColorCollection;
-(void)resetSortedArrays;

-(NSArray *)sortedColorKeysForSortMode:(ColorSortMode)aColorSortMode;
-(ColorObject *)colorObjectAtIndex:(NSInteger)index withSortMode:(ColorSortMode)sortMode;
-(NSInteger)numberOfColorObjects;
-(ColorObject *)colorObjectForKey:(NSString *)colorKeyString;
-(NSInteger)indexForKey:(NSString *)aKey usingSortMode:(ColorSortMode)sortMode;

@end
