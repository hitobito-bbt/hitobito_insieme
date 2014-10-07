# encoding: utf-8

#  Copyright (c) 2012-2014, insieme Schweiz. This file is part of
#  hitobito_insieme and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_insieme.

module HitobitoInsieme
  class Wagon < Rails::Engine
    include Wagons::Wagon

    # Set the required application version.
    app_requirement '>= 0'

    # Add a load path for this specific wagon
    config.autoload_paths += %W( #{config.root}/app/abilities
                                 #{config.root}/app/decorators
                                 #{config.root}/app/domain
                                 #{config.root}/app/jobs
                             )

    config.to_prepare do
      # rubocop:disable SingleSpaceBeforeFirstArg
      # extend application classes here
      Group.send         :include, Insieme::Group
      Person.send        :include, Insieme::Person
      Event::Course.send :include, Insieme::Event::Course
      Event::Participation.send :include, Insieme::Event::Participation
      Event::Role::Permissions << :reporting

      Event::Course.send    :include, Insieme::Event::Course

      PersonSerializer.send :include, Insieme::PersonSerializer
      GroupSerializer.send  :include, Insieme::GroupSerializer

      GroupAbility.send       :include, Insieme::GroupAbility
      EventAbility.send       :include, Insieme::EventAbility
      PersonAbility.send      :include, Insieme::PersonAbility
      MailingListAbility.send :include, Insieme::MailingListAbility
      VariousAbility.send     :include, Insieme::VariousAbility
      PersonAccessibles.send  :include, Insieme::PersonAccessibles
      Ability.store.register Event::CourseRecordAbility

      PeopleController.send :include, Insieme::PeopleController
      EventsController.send :include, Insieme::EventsController
      Event::ParticipationsController.send :include, Insieme::Event::ParticipationsController

      Sheet::Base.send  :include, Insieme::Sheet::Base
      Sheet::Group.send :include, Insieme::Sheet::Group
      Sheet::Event.send :include, Insieme::Sheet::Event

      Export::Csv::People::PeopleAddress.send :include, Insieme::Export::Csv::People::PeopleAddress
      Import::PersonDoubletteFinder.send :include, Insieme::Import::PersonDoubletteFinder
      # rubocop:enable SingleSpaceBeforeFirstArg
    end

    initializer 'insieme.add_settings' do |_app|
      Settings.add_source!(File.join(paths['config'].existent, 'settings.yml'))
      Settings.reload!
    end

    private

    def seed_fixtures
      fixtures = root.join('db', 'seeds')
      ENV['NO_ENV'] ? [fixtures] : [fixtures, File.join(fixtures, Rails.env)]
    end

  end
end
