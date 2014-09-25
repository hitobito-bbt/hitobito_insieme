# encoding: utf-8

#  Copyright (c) 2012-2014, insieme Schweiz. This file is part of
#  hitobito_insieme and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_insieme.

module Insieme
  module Event::ParticipationsController
    extend ActiveSupport::Concern

    PERSON_ATTRIBUTES = [:id, :canton, :birthday, :address, :zip_code, :town, :country,
                         :correspondence_course_full_name,
                         :correspondence_course_company_name,
                         :correspondence_course_company,
                         :correspondence_course_address,
                         :correspondence_course_zip_code,
                         :correspondence_course_town,
                         :correspondence_course_country,
                         :billing_course_full_name,
                         :billing_course_company_name,
                         :billing_course_company,
                         :billing_course_address,
                         :billing_course_zip_code,
                         :billing_course_town,
                         :billing_course_country]

    included do
      self.permitted_attrs += [person_attributes: PERSON_ATTRIBUTES]
    end
  end
end