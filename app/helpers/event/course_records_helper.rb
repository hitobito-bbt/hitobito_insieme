# encoding: utf-8

#  Copyright (c) 2012-2014, insieme Schweiz. This file is part of
#  hitobito_insieme and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_insieme.

module Event::CourseRecordsHelper

  def kursart_label(art)
    t("activerecord.attributes.event/course_record.kursarten.#{art}")
  end

  def gemeinkostenanteil_with_updated_at(record)
    string = format_money(record.gemeinkostenanteil)
    if record.gemeinkosten_updated_at
      string = safe_join([string,
                          ' &nbsp; &nbsp; '.html_safe,
                          t('event.course_records.form.updated_at',
                            date: format_attr(record, :gemeinkosten_updated_at))])
    end
    string
  end

  def zugeteilte_kategorie_with_info(record)
    if record.subventioniert
      record.zugeteilte_kategorie
    else
      safe_join([record.zugeteilte_kategorie.to_s,
                 ' &nbsp; &nbsp; '.html_safe,
                 t('event.course_records.form.info_not_subsidized')])
    end
  end

  def participant_field(form, attr, opts = {})
    opts.merge!(addon: t('global.persons_short')) unless opts[:addon]
    form.labeled_input_field(attr, opts)
  end

  def participant_field_with_suggestion(form, attr, suggestion, opts = {})
    if event_may_have_participants?
      help_text = t('event.course_records.form.according_to_list', count: f(suggestion))
      opts[:help_inline] = muted(help_text)
    end
    participant_field(form, attr, opts)
  end

  def format_general_cost_allowance_percent(allowance)
    if allowance
      format_percent(allowance * 100)
    else
      ''
    end
  end

  def participant_readonly_value_with_suggestion(form, attr, value, suggestion, opts = {})
    opts[:value] = value
    if event_may_have_participants?
      help_text = t('event.course_records.form.according_to_list', count: suggestion)
      opts[:help_inline] = help_text
    end
    form.labeled_readonly_value(attr, opts)
  end

  def event_may_have_participants?
    entry.event.class.role_types.present?
  end

end
