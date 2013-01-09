#ifndef __Muni__StandardEnvironment__
#define __Muni__StandardEnvironment__

#import "Environment.h"
#import "Field.h"
#import <vector>
#import "MNStandardCell.h"
#import "SpatialIndex.h"
#import "CellScanningResult.h"

namespace muni {
	class StandardEnvironment : public Environment {
	private:
		const Field field_;
		std::vector<id<MNCell> > cells_;
		const int max_cell_count_;
		std::vector<id<MNCell> > added_cells_queue_;
		const double incidence_;
		muni::SpatialIndex<id<MNCell> > spatial_index_;
		void update_spatial_index_for(id<MNCell> cell);
		void add_cells_from_queue();
		void remove_dead_cells();
		void apply_cells_dying();
		void apply_cells_hitting();
	public:
		StandardEnvironment(const juiz::Size &size, const int max_cell_count);
		virtual const Field field() const;
		virtual const std::vector<id<MNCell> > cells() const;
		virtual void send_frame();
		virtual void add_cell(id<MNCell> cell);
		virtual const std::vector<muni::CellScanningResult> cells_in_circle(const juiz::Point &center, const double radius, BOOL (^confition)(id<MNCell> other));
	};
}

#endif /* defined(__Muni__StandardEnvironment__) */
