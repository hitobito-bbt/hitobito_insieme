# frozen_string_literal: true

#  Copyright (c) 2012-2014, insieme Schweiz. This file is part of
#  hitobito_insieme and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_insieme.

# rubocop:disable Metrics/BlockLength

# Original from: https://github.com/thams/db_fixtures_dump/
namespace :db do
  namespace :fixtures do
    desc 'Dumps some models into fixtures.'
    task dump: :environment do
      Rake::Task['fixtures:groups'].invoke

      puts '# Please copy this into the spec/fixtures/groups.yml yourself'
    end
  end

  namespace :import do
    desc <<~TEXT
      Import summed values for capital substrates for earlier years

      This import expects a CSV-File (named previous_capital_substrates.csv by default)
      with two fields:
        - group_id (numeric id of the group)
        - sum      (sum of previous Vertragsperioden, float-parseable)
    TEXT
    task :previous_capital_substrates, [:year, :filename] => [:environment] do |_, args|
      args.with_defaults(filename: 'previous_capital_substrates.csv')
      abort 'this needs a year in which the capitalsubstrates are summed up' if args.year.nil?

      puts 'Importing summed values for capital substrates of previous years'
      puts "Reading from:   #{args.filename}"
      puts "Storing sum in: #{args.year}"

      cs_sum_csv = Pathname.new(args.filename)

      abort 'Import file not found' unless cs_sum_csv.exist?

      unless cs_sum_csv.each_line.first =~ /group_id.*sum/
        abort 'Import file is not in the expected format'
      end

      require 'csv'

      puts 'Importing data'
      errors = []
      CSV.parse(cs_sum_csv.read, headers: true).each do |row|
        cs = CapitalSubstrate.find_or_create(year: args.year, group_id: row['group_id'])
        cs.previous_substrate_sum = row['sum']
        if cs.save
          print '.'
        else
          print 'E'
          errors << [cs, row]
        end
      end
      puts
      puts 'Done.'

      if errors.any?
        puts
        puts "There have been #{errors.size} Errors:"

        errors.each do |cs, row|
          puts cs.inspect, row.inspect
        end
        puts 'End of Errors.'
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
