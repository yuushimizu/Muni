#import "MNStandardCell.h"
#import "JZUtility.h"

#define kMNCellMinDensity 0.2
#define kMNCellMaxDensity 0.9

static int randomType() {
	static int nextType = 0;
	int type = nextType;
	nextType = (nextType + 1) % kMNCellTypeCount;
	return type;
}

@implementation MNStandardCell

@synthesize type = _type;
@synthesize age = _age;
@synthesize maxEnergy = _maxEnergy;
@synthesize energy = _energy;
@synthesize density = _density;
@synthesize family = _family;
@synthesize speed = _speed;
@synthesize movingRadian = _movingRadian;
@synthesize sight = _sight;
@synthesize center = _center;
@synthesize angle = _angle;
@synthesize rotationRadian = _rotationRadian;
@synthesize actionSources = _actionSources;
@synthesize lastMovedDistance = _lastMovedDistance;
@synthesize lastMovedRadian = _lastMovedRadian;
@synthesize maxBeat = _maxBeat;
@synthesize beat = _beat;

- (double)randomEnergy {
	// 700 - 7700
	return 700 + MNRandomDouble(0, 10) * MNRandomDouble(0, 10) * MNRandomDouble(3, 10) * MNRandomDouble(0, 7);
}

- (double)randomSpeed {
	// 0.5 - 4.5
	return 0.5 + MNRandomDouble(0, 2) * MNRandomDouble(0, 2);
}

- (muni::CellFamily)randomFamily {
	return muni::CellFamily(MNRandomDouble(0, 1));
}

- (MNCellAction *(^)(id<MNCell>, muni::Environment *))randomStandaloneMoveSource {
	int type = MNRandomInt(0, 100);
	if (type < 50) {
		int maxIntervalFrames = MNRandomInt(0, 100);
		return ^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellMoveRandomWalk alloc] initWithMaxIntervalFrames:maxIntervalFrames withEnvironment:environment];
		};
	} else if (type < 75) {
		return ^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellMoveFloat alloc] init];
		};
	} else {
		return ^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellMoveImmovable alloc] init];
		};
	}
}

- (MNCellAction *(^)(id<MNCell>, muni::Environment *))randomRelativeMoveSource:(MNCellAction *(^)(id<MNCell>, muni::Environment *))standaloneMoveSource {
	BOOL (^targetCondition)(id<MNCell> me, id<MNCell> other);
	int type = MNRandomInt(0, 100);
	if (type < 75) {
		targetCondition = ^(id<MNCell> me, id<MNCell> other) {return (BOOL) (me != other && [me hostility:other]);};
	} else {
		targetCondition = ^(id<MNCell> me, id<MNCell> other) {return (BOOL) (me != other && ![me hostility:other]);};
	}
	int decisionMoveWithTarget = MNRandomInt(0, 100);
	if (decisionMoveWithTarget < 20) {
		return ^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellMoveApproachTarget alloc] initWithCell:cell withCondition:targetCondition withMoveWithoutTarget:standaloneMoveSource(cell, environment)];
		};
	} else if (decisionMoveWithTarget < 40) {
		return ^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellMoveEscape alloc] initWithCell:cell withCondition:targetCondition withMoveWhenNotEscape:standaloneMoveSource(cell, environment)];
		};
	} else if (decisionMoveWithTarget < 60) {
		return ^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellMoveApproachNearestTarget alloc] initWithCell:cell withCondition:targetCondition withMoveWithoutTarget:standaloneMoveSource(cell, environment)];
		};
	} else if (decisionMoveWithTarget < 80) {
		int intervalFrames = MNRandomInt(30, 150);
		return ^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellMoveTraceTarget alloc] initWithCell:cell withCondition:targetCondition withMoveWithoutTarget:standaloneMoveSource(cell, environment) withIntervalFrames:intervalFrames];
		};
	} else {
		double distanceRate = MNRandomDouble(1, 4);
		double radianIncrease = MNRandomDouble(3.0 * M_PI / 180.0, 12.0 * M_PI / 180.0) * (MNRandomBool() ? 1 : -1);
		return ^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellMoveMoon alloc] initWithCell:cell withCondition:targetCondition withMoveWithoutTarget:standaloneMoveSource(cell, environment) withDistance:distanceRate * cell.radius withRadianIncrease:radianIncrease];
		};
	}
}

- (MNCellAction *(^)(id<MNCell>, muni::Environment *))randomMoveSourceWithoutCondition {
	MNCellAction *(^standaloneMoveSource)(id<MNCell>, muni::Environment *) = [self randomStandaloneMoveSource];
	if (MNRandomInt(0, 100) < 10) {
		return standaloneMoveSource;
	} else {
		return [self randomRelativeMoveSource:standaloneMoveSource];
	}
}

- (MNCellAction *(^)(id<MNCell>, muni::Environment *))randomMoveSource {
	MNCellAction *(^moveSourceWithoutCondition)(id<MNCell>, muni::Environment *) = [self randomMoveSourceWithoutCondition];
	if (MNRandomInt(0, 100) < 75) {
		return moveSourceWithoutCondition;
	} else {
		double energyBoundingRate = MNRandomDouble(0.3, 0.7);
		MNCellAction *(^falseMoveSource)(id<MNCell>, muni::Environment *) = [self randomMoveSourceWithoutCondition];
		return ^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellActionConditional alloc] initWithCondition:^(id<MNCell> cell) {
				return (BOOL) ((cell.energy / cell.maxEnergy) < energyBoundingRate);
			} withTrueAction:moveSourceWithoutCondition(cell, environment) withFalseAction:falseMoveSource(cell, environment)];
		};
	}
}

- (NSArray *)randomActionSources {
	NSMutableArray *actionSources = [NSMutableArray arrayWithObject:[self randomMoveSource]];
	if (MNRandomInt(0, 100) < 75) {
		int maxCount = MNRandomInt(1, 3) * MNRandomInt(1, 3) * MNRandomInt(1, 3) * MNRandomInt(1, 3);
		double incidence = MNRandomDouble(0.005, 0.015) - ((double) _maxEnergy / 1000000);
		[actionSources addObject:^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellActionMultiply alloc] initWithMaxCount:maxCount withIncidence:incidence];
		}];
	}
	if (MNRandomInt(0, 100) < 10) {
		double distanceRate = MNRandomDouble(1, 2);
		double radianIncrease = MNRandomDouble(3.0 * M_PI / 180.0, 12.0 * M_PI / 180.0) * (MNRandomBool() ? 1 : -1);
		int maxCount = MNRandomInt(1, 4) * MNRandomInt(1, 2);
		double incidence = 0.002;
		[actionSources addObject:^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellActionMakeMoon alloc] initWithDistance:distanceRate * cell.radius withRadianIncrease:radianIncrease withMaxCount:maxCount withIncidence:incidence];
		}];
	}
	if (MNRandomInt(0, 100) < 10) {
		int intervalFrames = MNRandomInt(30, 450);
		double incidence = 0.003;
		[actionSources addObject:^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellActionMakeTracer alloc] initWithIntervalFrames:intervalFrames withIncidence:incidence];
		}];
	}
	return actionSources;
}

- (void)resetActionsWithEnvironment:(muni::Environment *)environment {
	NSMutableArray *actions = [NSMutableArray array];
	for (MNCellAction *(^actionSource)(id<MNCell>, muni::Environment *environment) in _actionSources) {
		[actions addObject:actionSource(self, environment)];
	}
	_actions = actions;
}

- (void)fixPositionWithEnvironment:(muni::Environment *)environment {
	double radius = self.radius;
	if (_center.x() < radius) {
		_center = juiz::Point(radius, _center.y());
		_movingRadian = -_movingRadian;
	} else if (_center.x() > environment->field().size().width() - radius) {
		_center = juiz::Point(environment->field().size().width() - radius, _center.y());
		_movingRadian = -_movingRadian;
	}
	if (_center.y() < radius) {
		_center = juiz::Point(_center.x(), radius);
		_movingRadian = -M_PI - _movingRadian;
	} else if (_center.y() > environment->field().size().height() - radius) {
		_center = juiz::Point(_center.x(), environment->field().size().height() - radius);
		_movingRadian = -M_PI - _movingRadian;
	}
}

- (void)realMove:(muni::Environment *)environment {
	_center = JZMovedPoint(JZMovedPoint(_center, _radianForFix, _distanceForFix), _movingRadian, _movingSpeed);
	_distanceForFix = 0;
	[self fixPositionWithEnvironment:environment];
}

- (void)moveFor:(double)radian withForce:(double)force {
	const juiz::Point pointMoved(_center.x() + ((sin(_movingRadian) * _movingSpeed) + (sin(radian) * force)), _center.y() + ((cos(_movingRadian) * _movingSpeed) + (cos(radian) * force)));
	const juiz::Vector move_vector = juiz::vector(_center, pointMoved);
	_movingSpeed = move_vector.magnitude();
	_movingRadian = move_vector.direction().clockwise_angle_with_above();

}

- (void)moveFor:(double)radian withTargetSpeed:(double)targetSpeed {
	const juiz::Point movingPoint = JZMovedPoint(_center, _movingRadian, _movingSpeed);
	const juiz::Point targetPoint = JZMovedPoint(_center, radian, targetSpeed);
	const juiz::Vector move_vector = juiz::vector(movingPoint, targetPoint);
	[self moveFor:move_vector.direction().clockwise_angle_with_above() withForce:MIN(move_vector.magnitude(), _speed * 0.2 * (1 - _density))];
}

- (void)moveFor:(double)radian {
	[self moveFor:radian withTargetSpeed:_speed];
}

- (void)accelerate {
	[self moveFor:_movingRadian];
}

- (void)stop {
	[self moveFor:JZInvertRadian(_movingRadian) withTargetSpeed:0];
}

- (void)moveTowards:(const juiz::Point &)point {
	[self moveFor:JZRadianFromPoints(_center, point)];
}

- (void)moveForFix:(double)radian distance:(double)distance {
	const juiz::Point pointMoved(_center.x() + ((sin(_radianForFix) * _distanceForFix) + (sin(radian) * distance)), _center.y() + ((cos(_radianForFix) * _distanceForFix) + (cos(radian) * distance)));
	const juiz::Vector vector_for_move = juiz::vector(_center, pointMoved);
	_distanceForFix = vector_for_move.magnitude();
	_radianForFix = vector_for_move.direction().clockwise_angle_with_above();
}

- (void)rotateFor:(double)radian {
	if (_rotationRadian == 0) {
		while (radian < 0) radian += M_PI * 2;
		while (radian >= M_PI * 2) radian -= M_PI * 2;
		double clockwiseDiff;
		double counterclockwiseDiff;
		if (_angle < radian) {
			clockwiseDiff = radian - _angle;
			counterclockwiseDiff = _angle + M_PI * 2 - radian;
		} else {
			clockwiseDiff = radian + M_PI * 2 - _angle;
			counterclockwiseDiff = _angle - radian;
		}
		if (fabs(clockwiseDiff) > fabs(counterclockwiseDiff)) {
			_angle += MIN(counterclockwiseDiff * 0.1, -M_PI * 0.01);
		} else {
			_angle += MIN(clockwiseDiff * 0.1, M_PI * 0.01);
		}
		while (_angle < 0) _angle += M_PI * 2;
		while (_angle >= M_PI * 2) _angle -= M_PI * 2;
	}
}

- (void)rotateTowards:(const juiz::Point &)point {
	[self rotateFor:JZRadianFromPoints(_center, point)];
}

- (id)init {
	if (self = [super init]) {
		_age = 0;
		_movingSpeed = 0;
		_movingRadian = MNRandomRadian();
		_previousEventBits = 0;
		_distanceForFix = 0;
		_beat = 0;
	}
	return self;
}

- (id)initByRandomWithEnvironment:(muni::Environment *)environment {
	if (self = [super init]) {
		_type = randomType();
		_maxEnergy = [self randomEnergy];
		_energy = _maxEnergy * MNRandomDouble(0.5, 0.9);
		_density = MNRandomDouble(kMNCellMinDensity, kMNCellMaxDensity);
		_family = [self randomFamily];
		_speed = [self randomSpeed];
		_angle = MNRandomRadian();
		_rotationRadian  = MNRandomInt(0, 100) < 30 ? MNRandomDouble(-0.05, 0.05) + MNRandomDouble(-0.05, 0.05) + MNRandomDouble(-0.05, 0.05) + MNRandomDouble(-0.05, 0.05) + MNRandomDouble(-0.05, 0.05) + MNRandomDouble(-0.05, 0.05) : 0;
		_sight = JZDiagonalFromSize(environment->field().size()) * MNRandomDouble(0.1, 0.5);
		_center = MNRandomPointInSize(environment->field().size());
		[self fixPositionWithEnvironment:environment];
		_actionSources = [self randomActionSources];
		[self resetActionsWithEnvironment:environment];
		_maxBeat = MNRandomInt(5, 60) * 2;
	}
	return self;
}

- (id)initByOther:(MNStandardCell *)other withEnvironment:(muni::Environment *)environment {
	if (self = [super init]) {
		_type = other.type;
		_maxEnergy = other.maxEnergy * MNRandomDouble(0.9, 1.1);
		_energy = _maxEnergy * other.energy / other.maxEnergy;
		_density = MAX(MIN(kMNCellMaxDensity, other.density * MNRandomDouble(0.9, 1.1)), kMNCellMinDensity);
		_family = muni::CellFamily(other.family.value() * MNRandomDouble(0.9, 1.1));
		_speed = other.speed * MNRandomDouble(0.9, 1.1);
		_angle = other.angle;
		_rotationRadian = other.rotationRadian;
		_sight = other.sight * MNRandomDouble(0.9, 1.1);
		_center = JZMovedPoint(other.center, MNRandomRadian(), other.radius);
		[self fixPositionWithEnvironment:environment];
		_actionSources = other.actionSources;
		[self resetActionsWithEnvironment:environment];
		_maxBeat = other.maxBeat;
		_beat = other.beat;
	}
	return self;
}

- (id)initAsTracerOf:(MNStandardCell *)parent withIntervalFrames:(int)intervalFrames withEnvironment:(muni::Environment *)environment {
	if (self = [super init]) {
		_type = parent.type;
		_energy = parent.energy * 0.9;
		_maxEnergy = parent.maxEnergy * 0.9;
		_density = parent.density;
		_family = parent.family;
		_speed = parent.speed;
		_angle = parent.angle;
		_rotationRadian = parent.rotationRadian;
		_sight = parent.sight;
		_center = JZMovedPoint(parent.center, MNRandomRadian(), parent.radius);
		[self fixPositionWithEnvironment:environment];
		MNCellAction *(^moveSourceWithoutTarget)(id<MNCell>, muni::Environment *) = [self randomMoveSource];
		MNCellAction *(^moveSoure)(id<MNCell>, muni::Environment *) = ^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellMoveTraceTarget alloc] initWithCell:cell withCondition:^(id<MNCell> me, id<MNCell> other) {return (BOOL) (other == parent);} withMoveWithoutTarget:moveSourceWithoutTarget(cell, environment) withIntervalFrames:intervalFrames];
		};
		MNCellAction *(^makeTracerSource)(id<MNCell>, muni::Environment *) = ^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellActionMakeTracer alloc] initWithIntervalFrames:intervalFrames withIncidence:0.001];
		};
		_actionSources = [NSArray arrayWithObjects:moveSoure, makeTracerSource, nil];
		[self resetActionsWithEnvironment:environment];
		_maxBeat = parent.maxBeat;
		_beat = parent.beat;
	}
	return self;
}

- (id)initAsMoonOf:(MNStandardCell *)parent withDistance:(double)distance withRadianIncrease:(double)radianIncrease withEnvironment:(muni::Environment *)environment {
	if (self = [super init]) {
		_type = parent.type;
		_maxEnergy = parent.maxEnergy * 0.5;
		_energy = _maxEnergy * 0.5;
		_density = parent.density;
		_family = parent.family;
		_speed = parent.speed * 2;
		_angle = parent.angle;
		_rotationRadian = parent.rotationRadian;
		_sight = parent.sight + distance;
		_center = JZMovedPoint(parent.center, MNRandomRadian(), parent.radius + distance + self.radius);
		[self fixPositionWithEnvironment:environment];
		_actionSources = [NSArray arrayWithObject:^(id<MNCell> cell, muni::Environment *environment) {
			return [[MNCellMoveMoon alloc] initWithCell:cell withCondition:^(id<MNCell> me, id<MNCell> other) {return (BOOL) (other == parent);} withMoveWithoutTarget:[[MNCellMoveFloat alloc] init] withDistance:distance withRadianIncrease:radianIncrease];
		}];
		[self resetActionsWithEnvironment:environment];
		_maxBeat = parent.maxBeat;
		_beat = parent.beat;
	}
	return self;
}

- (double)radius {
	return _maxEnergy * 0.01;
}

- (double)weight {
	return self.radius * _density;
}

- (BOOL)living {
	return _energy > 0;
}

- (const std::vector<muni::CellScanningResult>)scanCellsWithCondition:(BOOL (^)(id<MNCell>))condition withEnvironment:(muni::Environment *)environment {
	return environment->cells_in_circle(_center, _sight + self.radius, condition);
}

- (BOOL)hostility:(id<MNCell>)other {
	return muni::hostility(_family, other.family);
}

- (void)decreaseEnergy:(double)energy {
	_energy -= energy;
	if (_energy <= 0) {
		_energy = 0;
		_eventBits |= kMNCellEventDied;
	}
}

- (void)damage:(double)damage {
	[self decreaseEnergy:damage];
	_eventBits |= kMNCellEventDamaged;
}

- (void)heal:(double)energy {
	_energy = MIN(_energy + energy, _maxEnergy);
}

- (BOOL)multiplyWithEnvironment:(muni::Environment *)environment {
	double cost = self.maxEnergy * 0.25;
	if (self.energy < cost * 2) return NO;
	[self decreaseEnergy:cost];
	MNStandardCell *newCell = [[MNStandardCell alloc] initByOther:self withEnvironment:environment];
	environment->add_cell(newCell);
	return YES;
}

- (BOOL)makeMoonWithDistance:(double)distance withRadianIncrease:(double)radianIncrease withEnvironment:(muni::Environment *)environment {
	if (self.maxEnergy < 200) return NO;
	if (self.energy < self.maxEnergy * 0.15) return NO;
	[self decreaseEnergy:self.maxEnergy * 0.1];
	MNStandardCell *moon = [[MNStandardCell alloc] initAsMoonOf:self withDistance:distance withRadianIncrease:radianIncrease withEnvironment:environment];
	environment->add_cell(moon);
	return YES;
}

- (BOOL)makeTracerWithIntervalFrames:(int)intervalFrames withEnvironment:(muni::Environment *)environment {
	if (self.maxEnergy < 200) return NO;
	if (self.energy < self.maxEnergy * 0.25) return NO;
	[self decreaseEnergy:self.maxEnergy * 0.2];
	MNStandardCell *newCell = [[MNStandardCell alloc] initAsTracerOf:self withIntervalFrames:intervalFrames withEnvironment:environment];
	environment->add_cell(newCell);
	return YES;
}

- (BOOL)eventOccurred:(int)event {
	return _eventBits & event;
}

- (BOOL)eventOccurredPrevious:(int)event {
	return _previousEventBits & event;
}

- (double)beatingRadius {
	double baseRadius = self.radius;
	return baseRadius + baseRadius * 0.05 * sin(M_PI * _beat / _maxBeat) - baseRadius * 0.025;
}

- (void)sendFrameWithEnvironment:(muni::Environment *)environment {
	_age += 1;
	_beat += 1;
	if (_beat >= _maxBeat) _beat = 0;
	if (_rotationRadian != 0) {
		_angle += _rotationRadian;
		if (_angle >= M_PI * 2) {
			_angle -= M_PI * 2;
		} else if (_angle < 0) {
			_angle += M_PI * 2;
		}
	}
	_previousEventBits = _eventBits;
	_eventBits = 0;
	_lastMovedRadian = _movingRadian;
	_lastMovedDistance = _movingSpeed;
	[self decreaseEnergy:self.weight * 0.03];
	if (self.living) for (MNCellAction *action in _actions) {
		[action sendFrameWithCell:self withEnvironment:environment];
	}
}

@end
