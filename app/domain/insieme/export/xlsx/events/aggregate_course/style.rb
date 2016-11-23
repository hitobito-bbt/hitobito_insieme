# encoding: utf-8

#  Copyright (c) 2014 Insieme Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_insieme.

module Insieme::Export::Xlsx::Events::AggregateCourse
  class Style < Export::Xlsx::Style

    BLACK = '000000'.freeze
    CURRENCY = 2
    DATE = 14

    self.data_row_height = 130

    self.style_definition_labels += [:header, :default_border,
                                     :centered_border, :vertical_centered,
                                     :currency, :date,
                                     :centered_border_small, :centered_border_wrap]

    def column_widths
      [18, 12.86, 40] +
        Array.new(24, 2.57) +
        [17.14, 4.29, 3.71, 2.57, 14] +
        Array.new(18, 4.29) +
        Array.new(9, 7.5) +
        [3.13]
    end

    def row_styles
      [].tap do |row|
      end
    end

    def default_style_data_rows
      Array.new(2, :centered_border_wrap) +
        [:centered_border_small] +
        Array.new(21, :vertical_centered) +
        Array.new(2, :centered_border) +
        [:centered_border_wrap] +
        Array.new(4, :centered_border) +
        [:centered_border_wrap] +
        Array.new(18, :centered_border) +
        Array.new(9, :currency) +
        [:centered_border]
    end

    def style_title_header_row
      [:header] +
        Array.new(3, :header) +
        Array.new(12, :header) +
        Array.new(31, :default) +
        Array.new(33, :default) +
        Array.new(66, :default) +
        Array.new(67, :default)
    end

    private

    # override default style
    def default_style
      { style: {
        font_name: Settings.xlsx.font_name, sz: 10, alignment: { horizontal: :left }
      } }
    end

    # override default attribute labels style
    def attribute_labels_style
      default_border_style.deep_merge(
        style: {
          bg_color: LABEL_BACKGROUND,
          alignment: { text_rotation: 90, vertical: :center, horizontal: :center }
        },
        height: 285
      )
    end

    def vertical_centered_style
      default_border_style.deep_merge(
        style: {
          alignment: { text_rotation: 90, vertical: :center, horizontal: :center }
        }
      )
    end

    def default_border_style
      default_style.deep_merge(border_styling)
    end

    def centered_border_style
      centered_style.deep_merge(border_styling).deep_merge(
        style: {
          alignment: { vertical: :center, horizontal: :center }
        }
      )
    end

    def centered_border_wrap_style
      centered_border_style.deep_merge(style: { alignment: { wrap_text: true } })
    end

    def centered_border_small_style
      centered_border_style.deep_merge(style: { sz: 8, alignment: { wrap_text: true } })
    end

    def currency_style
      centered_border_style.deep_merge(
        style: { num_fmt: CURRENCY }
      )
    end

    def date_style
      centered_border_style.deep_merge(
        style: { num_fmt: DATE }
      )
    end

    def border_styling
      { style: { border: { style: :thin, color: BLACK } } }
    end

    def header_style
      default_style.deep_merge(style: { sz: 16 })
    end
  end
end