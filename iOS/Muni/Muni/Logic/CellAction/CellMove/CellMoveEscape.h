#ifndef __Muni__CellMoveEscape__
#define __Muni__CellMoveEscape__

#import "CellAction.h"
#import "MNCell.h"
#import "MNUtility.h"
#import <memory>

namespace muni {
	template <typename EscapeConditionFunction>
	class CellMoveEscape : public CellAction {
	private:
		EscapeConditionFunction escape_condition_;
		std::shared_ptr<CellAction> action_when_not_escape_;
	public:
		CellMoveEscape(EscapeConditionFunction escape_condition, std::shared_ptr<CellAction> action_when_not_escape) : escape_condition_(escape_condition), action_when_not_escape_(action_when_not_escape) {
		}
		
		virtual void send_frame(id<MNCell> cell, Environment &environment) {
			std::vector<muni::CellScanningResult> scanning_results = [cell scanCellsWithCondition:^(id<MNCell> candidate) {
				return (BOOL) escape_condition_(cell, candidate);
			} withEnvironment:&environment];
			if (scanning_results.size() > 0) {
				double cell_x = cell.center.x();
				double cell_y = cell.center.y();
				double max_distance = cell.radius + cell.sight;
				double x_destination = cell_x;
				double y_destination = cell_y;
				for (auto scanningResult : scanning_results) {
					const juiz::Point pointWithMaxDistance = juiz::add_vector(cell.center, juiz::Vector(juiz::vector(cell.center, scanningResult.cell().center).direction(), max_distance));
					x_destination -= pointWithMaxDistance.x() - scanningResult.cell().center.x();
					y_destination -= pointWithMaxDistance.y() - scanningResult.cell().center.y();
				}
				if (cell_x > environment.field().size().width() / 2) {
					double distanceToWall = environment.field().size().width() - cell_x;
					if (distanceToWall < max_distance / 2) x_destination = cell_x;
				} else {
					if (cell_x < max_distance / 2) x_destination = cell_x;
				}
				if (cell_y > environment.field().size().height() / 2) {
					double distanceToWall = environment.field().size().height() - cell_y;
					if (distanceToWall < max_distance / 2) y_destination = cell_y;
				} else {
					if (cell_y < max_distance / 2) y_destination = cell_y;
				}
				double radian;
				if (x_destination == cell_x && y_destination == cell_y) {
					radian  = MNRandomRadian();
				} else {
					radian = juiz::vector(cell.center, juiz::Point(x_destination, y_destination)).direction().clockwise_angle_with_above();
				}
				[cell moveFor:radian];
				[cell rotateFor:radian];
			} else {
				action_when_not_escape_->send_frame(cell, environment);
			}
		}
	};
}

#endif /* defined(__Muni__CellMoveEscape__) */