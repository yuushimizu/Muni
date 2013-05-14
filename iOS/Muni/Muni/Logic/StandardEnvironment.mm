#include "StandardEnvironment.h"
#import "JZUtility.h"
#import "MNUtility.h"

namespace muni {
	StandardEnvironment::StandardEnvironment(const juiz::Size &size, const int max_cell_count) : field_(size), cells_(), max_cell_count_(max_cell_count), added_cells_queue_(), incidence_(0.07 * (size.width() * size.height()) / (480.0 * 320.0)), spatial_index_(muni::spatial_index_from_total_size_and_block_count<id<MNCell> >(size, juiz::Size(16, 16))) {
	}
	
	const Field StandardEnvironment::field() const {
		return this->field_;
	}
	
	const std::vector<id<MNCell> > StandardEnvironment::cells() const {
		return this->cells_;
	}
	
	void StandardEnvironment::update_spatial_index_for(id<MNCell> cell) {
		const double radius = cell.radius;
		this->spatial_index_.add_or_update_object(cell, CGRectMake(cell.center.x() - radius, cell.center.y() - radius, radius * 2, radius * 2));
	}
	
	void StandardEnvironment::add_cell(id<MNCell> cell) {
		this->added_cells_queue_.push_back(cell);
	}
	
	void StandardEnvironment::add_cells_from_queue() {
		for (auto cell : this->added_cells_queue_) {
			if (cells_.size() >= max_cell_count_) break;
			const double cell_radius = cell.radius;
			std::vector<id<MNCell> >::iterator iter;
			for (iter = this->cells_.begin(); iter != this->cells_.end() && (*iter).radius >= cell_radius; ++iter);
			this->cells_.insert(iter, cell);
			this->update_spatial_index_for(cell);
		}
		this->added_cells_queue_.clear();
	}

	const std::vector<muni::CellScanningResult> StandardEnvironment::cells_in_circle(const juiz::Point &center, const double radius, BOOL (^condition)(id<MNCell> other)) {
		std::vector<muni::CellScanningResult> scanning_results;
		for (id<MNCell> candidate : this->spatial_index_.objects_for_rect(CGRectMake(center.x() - radius, center.y() - radius, radius * 2, radius * 2))) {
			if (candidate.living) {
				double distance_from_center = juiz::vector(center, candidate.center).magnitude();
				if (distance_from_center - candidate.radius <= radius && (condition == nil || condition(candidate))) {
					double distance = distance_from_center - candidate.radius;
					std::vector<muni::CellScanningResult>::iterator iter;
					for (iter = scanning_results.begin(); iter != scanning_results.end() && (*iter).distance() <= distance; ++iter);
					scanning_results.insert(iter, muni::CellScanningResult(candidate, distance));
				}
			}
		}
		return scanning_results;
	}

	void StandardEnvironment::remove_dead_cells() {
		auto iter = this->cells_.begin();
		while (iter != this->cells_.end()) {
			id<MNCell> cell = *iter;
			if (!cell.living) {
				this->spatial_index_.remove_object(cell);
				iter = this->cells_.erase(iter);
			} else {
				++iter;
			}
		}
	}

	void StandardEnvironment::apply_cells_dying() {
		for (auto dead_cell : this->cells_) {
			if (!dead_cell.living) {
				double total_heal_energy = dead_cell.maxEnergy * 0.5;
				std::vector<muni::CellScanningResult> heal_target_scanning_results = this->cells_in_circle(dead_cell.center, dead_cell.radius * 3, ^(id<MNCell> cell){return (BOOL) (dead_cell != cell && [cell hostility:dead_cell]);});
				double total_distance = 0;
				for (auto scanning_result : heal_target_scanning_results) {
					total_distance += scanning_result.distance();
				}
				for (auto scanning_result : heal_target_scanning_results) {
					[scanning_result.cell() heal:total_heal_energy * MIN(scanning_result.distance() / total_distance, 0.5)];
				}
			}
		}
	}

	void StandardEnvironment::apply_cells_hitting() {
		const std::vector<id<MNCell> > collisions = this->spatial_index_.collisions();
		MNStandardCell *cell1 = nil;
		for (MNStandardCell *cell : collisions) {
			if (cell1 == nil) {
				cell1 = cell;
				continue;
			}
			MNStandardCell * cell2 = cell;
			if (cell1.living && cell2.living) {
				double distance = juiz::vector(cell1.center, cell2.center).magnitude();
				double piled_distance = cell1.radius + cell2.radius - distance;
				if (piled_distance > 0) {
					const juiz::Direction direction = juiz::direction(cell1.center, cell2.center);
					const juiz::Direction inverted_direction = juiz::invert(direction);
					double weight1 = cell1.weight;
					double weight2 = cell2.weight;
					if ([cell1 hostility:cell2]) {
						[cell1 moveForFix:inverted_direction.clockwise_angle_with_above() distance:piled_distance / 2 * (weight2 / (weight1 + weight2))];
						[cell2 moveForFix:direction.clockwise_angle_with_above() distance:piled_distance / 2 * (weight1 / (weight2 + weight1))];
						double total_knockback_distance = MIN(piled_distance / 2, 5);
						double min_knockback_distance = total_knockback_distance * 0.1;
						double rest_knockback_distance = total_knockback_distance - min_knockback_distance * 2;
						double density1 = cell1.density;
						double density2 = cell2.density;
						if (![cell1 eventOccurredPrevious:kMNCellEventDamaged]) {
							double knockback1 = min_knockback_distance + (rest_knockback_distance * (density2	/ (density1 + density2)));
							[cell1 moveFor:inverted_direction.clockwise_angle_with_above() withForce:knockback1];
							double damage = knockback1 * 50;
							[cell1 damage:damage];
						}
						if (![cell2 eventOccurredPrevious:kMNCellEventDamaged]) {
							double knockback2 = min_knockback_distance + (rest_knockback_distance * (density1 / (density2 + density1)));
							[cell2 moveFor:direction.clockwise_angle_with_above() withForce:knockback2];
							double damage = knockback2 * 50;
							[cell2 damage:damage];
						}
					} else {
						[cell1 moveForFix:inverted_direction.clockwise_angle_with_above() distance:piled_distance * (weight2 / (weight1 + weight2))];
						[cell2 moveForFix:direction.clockwise_angle_with_above() distance:piled_distance * (weight1 / (weight2 + weight1))];
					}
				}
			}
			cell1 = nil;
		}
	}
	
	void StandardEnvironment::send_frame() {
		this->remove_dead_cells();
		for (auto cell : this->cells_) [cell sendFrameWithEnvironment:this];
		this->apply_cells_hitting();
		this->apply_cells_dying();
		for (auto cell : this->cells_) {
			[(MNStandardCell *) cell realMove:this];
			this->update_spatial_index_for(cell);
		}
		if (this->cells_.size() < this->max_cell_count_ && (this->cells_.size() < this->max_cell_count_ / 30 || MNRandomDouble(0, this->cells_.size() + 10) < this->incidence_)) {
			this->add_cell([[MNStandardCell alloc] initByRandomWithEnvironment:this]);
		}
		this->add_cells_from_queue();
	}
}
