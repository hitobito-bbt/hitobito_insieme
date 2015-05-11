# encoding: utf-8

#  Copyright (c) 2015, insieme Schweiz. This file is part of
#  hitobito_insieme and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_insieme.

require 'spec_helper'
require 'csv'

describe Export::Csv::CourseReporting::ClientStatistics do

  let(:stats) { CourseReporting::ClientStatistics.new(2015) }

  let(:exporter) { described_class.new(stats) }

  before do
    create_course(2015, :be, 'bk',
                  { be: 1, ag: 2, zh: 3, other: 4 },
                  { be: 0, ag: 1, zh: 1, other: 2 })

    create_course(2015, :be, 'bk',
                  { be: 2, ag: 4, zh: 6, other: 8 },
                  { be: 1, ag: 2, zh: 3, other: 4 },
                  :aggregate_course)

    create_course(2015, :fr, 'tk',
                  { be: 1, ag: 1, other: 1 })
  end

  context '#to_csv' do
    let(:data) { [].tap { |csv| exporter.to_csv(csv) } }

    it 'exports data for all cantons' do
      expect(data.size).to eq(3 + Cantons.short_names.size + 1)
    end

    it 'contains correct sums' do
      expect(data[1]).to eq(['Geistig-/Lernbehinderte', 30, 14, 3, 0, 0, 0])
      expect(data[2]).to eq(['davon Mehrfachbehinderte', 15, nil, 1, nil, 0, nil])
      expect(data[3]).to eq(['Aargau', 6, 3, 1, 0, 0, 0])
      expect(data[4]).to eq(['Appenzell Innerrhoden', 0, 0, 0, 0, 0, 0])
      expect(data[6]).to eq(['Bern', 3, 1, 1, 0, 0, 0])
      expect(data.last).to eq(['Total', 30, 14, 3, 0, 0, 0])
    end

    it 'contains translated headers' do
      expect(data.first).to eq(['Behinderung / Kanton',
                                'Blockkurse Anzahl Behinderte (Personen)',
                                'Blockkurse Anzahl Angehörige (Personen)',
                                'Tageskurse Anzahl Behinderte (Personen)',
                                'Tageskurse Anzahl Angehörige (Personen)',
                                'Semester-/Jahreskurse Anzahl Behinderte (Personen)',
                                'Semester-/Jahreskurse Anzahl Angehörige (Personen)',
                                ])
    end

  end


  def create_course(year, group, leistungskategorie, challenged = {}, affiliated = {}, event_type = :course)
    event = Fabricate(event_type,
                      group_ids: [groups(group).id],
                      leistungskategorie: leistungskategorie)
    event.dates.create!(start_at: Time.zone.local(year, 05, 11))
    r = Event::CourseRecord.create!(event_id: event.id, year: year)
    r.create_challenged_canton_count!(challenged) if challenged.present?
    r.create_affiliated_canton_count!(affiliated) if affiliated.present?
    r.update!(teilnehmende_mehrfachbehinderte: challenged.values.sum / 2)
  end

end