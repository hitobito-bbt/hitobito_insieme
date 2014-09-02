# encoding: utf-8

#  Copyright (c) 2012-2014, insieme Schweiz. This file is part of
#  hitobito_insieme and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_insieme.

module CostAccounting
  module Report
    class TimeDistributed < Base

      TIME_FIELDS = %w(verwaltung
                       beratung
                       treffpunkte
                       blockkurse
                       tageskurse
                       jahreskurse
                       lufeb
                       mittelbeschaffung)

      self.used_fields += %w(verwaltung)

      delegate_editable_fields %w(aufwand_ertrag_fibu
                                  abgrenzung_fibu
                                  abgrenzung_dachorganisation)

      delegate :time_record, to: :table

      TIME_FIELDS.each do |f|
        define_method(f) do
          @time_fields ||= {}
          if aufwand_ertrag_ko_re > 0
            if time_record.total > 0
              @time_fields[f] ||= aufwand_ertrag_ko_re *
                                  time_record.send(f).to_d / time_record.total
            else
              @time_fields[f] ||= aufwand_ertrag_ko_re / TIME_FIELDS.size
            end
          end
        end
      end

    end
  end
end