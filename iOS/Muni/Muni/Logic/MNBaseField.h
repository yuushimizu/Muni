//
//  MNBaseField.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNBaseField : NSObject {
	CGSize _size;
}

@property (readonly) CGSize size;

- (id)initWithSize:(CGSize)size;

@end
