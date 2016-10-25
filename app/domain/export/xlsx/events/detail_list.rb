# encoding: utf-8

#  Copyright (c) 2014 Insieme Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_insieme.

module Export::Xlsx::Events
  class DetailList < ::Export::Xlsx::Events::List

    self.style_class = Insieme::Export::Xlsx::Events::Style

    def initialize(list, group_name, year, title)
      @group_name = group_name
      @year = year
      @list = list
      @title = title
      add_header_rows
    end
    
    COURSE_RECORD_ATTRS = [
      :leistungskategorie, :year,:subventioniert, :inputkriterien,
      :kursart, :spezielle_unterkunft, :anzahl_kurse,
      :kursdauer,
      ## effektiv teilnehmende
      :teilnehmende_behinderte, :teilnehmende_mehrfachbehinderte,
      :teilnehmende_angehoerige, :teilnehmende_weitere,
      ## absenztage
      :absenzen_behinderte, :absenzen_angehoerige, :absenzen_weitere,
      ## total teilnehmerinnentage
      :tage_behinderte, :tage_angehoerige, :tage_weitere,
      ## betreuerinnen
      :leiterinnen, :fachpersonen,
      :hilfspersonal_mit_honorar, :hilfspersonal_ohne_honorar,
      ## personal ohne betreuungsfunktion
      :kuechenpersonal,
      ## direkter aufwand
      :honorare_inkl_sozialversicherung, :unterkunft, :uebriges,
      :direkter_aufwand,
      # ertrag
      :beitraege_teilnehmende,
      # auswertungen
      :gemeinkostenanteil, :total_vollkosten,
      :total_tage_teilnehmende, :vollkosten_pro_le,
      :zugeteilte_kategorie
    ]

    self.row_class = Export::Csv::Events::DetailRow

    private

    def build_attribute_labels
      super.tap do |labels|
        add_additional_course_record_labels(labels)
      end
    end

    def add_additional_course_record_labels(labels)
      COURSE_RECORD_ATTRS.each do |attr|
        add_course_record_label(labels, attr)
      end
    end
    
    def add_course_record_label(labels, attr)
      label = translate(attr.to_s, default: ::Event::CourseRecord.human_attribute_name(attr))
      labels[attr] = label
    end

    def add_header_rows
      add_header_row
      add_header_row(title_header_values, style.style_title_header_row)
      add_header_row
    end

    def title_header_values
      row = Array.new(18)
      row[0] = @group_name
      row[3] = reporting_year
      row[12] = document_title
      row[66] = "#{I18n.t('global.printed')}: "
      row[67] = printed_at
      row
    end

    def document_title
      # translate
      str = ''
      str << I18n.t('event.lists.courses.xlsx_export_title')
      str << ': '
      str << @title
      str
    end

    def reporting_year
      str = ''
      str << I18n.t('cost_accounting.index.reporting_year')
      str << ': '
      str << @year.to_s
      str
    end

    def printed_at
      str = ''
      str << I18n.l(Time.zone.today)
      str << Time.zone.now.strftime(' %H:%M')
      str
    end

  end
end
