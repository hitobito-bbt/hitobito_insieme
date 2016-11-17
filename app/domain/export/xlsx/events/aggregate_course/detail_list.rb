# encoding: utf-8

#  Copyright (c) 2014 Insieme Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_insieme.

module Export::Xlsx::Events::AggregateCourse
  class DetailList < Export::Xlsx::Events::DetailList

    TITLE = I18n.t('activerecord.models.event/aggregate_course.other')

    self.style_class = Insieme::Export::Xlsx::Events::AggregateCourse::Style

    def title_header_values
      row = Array.new(18)
      row[0] = @group_name
      row[2] = reporting_year
      row[10] = document_title
      row[56] = "#{I18n.t('global.printed')}: "
      row[57] = printed_at
      row
    end

  end
end
