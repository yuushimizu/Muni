#import <Foundation/Foundation.h>
#import "MNCellAction.h"
#import "MNUtility.h"
#import "MNCell.h"

@interface MNCellActionMultiply : MNCellAction {
	int _restCount;
	double _incidence;
}

- (id)initWithMaxCount:(int)maxCount withIncidence:(double)incidence;

@end
