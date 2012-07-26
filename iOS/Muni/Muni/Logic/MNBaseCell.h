//
//  MNBaseCell.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNUtility.h"
#import "MNBaseField.h"

#define kMNCellTypeCount 2

@interface MNBaseCell : NSObject {
	MNBaseField *_field;
	CGPoint _center;
	int _type;
	double _maxEnergy;
	double _energy;
	double _density;
	UIColor *_color;
	double _speed;
	double _sight;
}

@property (readonly) MNBaseField *field;
@property (nonatomic, assign) CGPoint center;
@property (readonly) int type;
@property (nonatomic, assign) double maxEnergy;
@property (nonatomic, assign) double energy;
@property (readonly) double radius;
@property (readonly) double density;
@property (readonly) double weight;
@property (readonly) UIColor *color;
@property (readonly) double speed;
@property (readonly) double sight;
@property (readonly) BOOL living;

- (id)initWithField:(MNBaseField *)field withCenter:(CGPoint)center;
- (id)initByRandomWithField:(MNBaseField *)field;

@end
