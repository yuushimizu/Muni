#import "CellMoveMoon.h"

namespace muni {
	CellMoveMoon::CellMoveMoon(TargetConditionFunction target_condition, std::shared_ptr<CellAction> action_without_target, const double distance, const double radian_increase) : CellMoveWithTarget(target_condition, action_without_target), distance_(distance), radian_increase_(radian_increase) {
	}
	
	void CellMoveMoon::send_frame(id<MNCell> cell, id<MNCell> target, Environment &environment) {
		[cell rotateTowards:target.center];
		const juiz::Vector vector_from_target = juiz::vector(target.center, cell.center);
		[cell moveTowards:juiz::add_vector(target.center, juiz::Vector(juiz::rotate_clockwise(vector_from_target.direction(), radian_increase_), distance_ + cell.radius + target.radius))];
	}
}