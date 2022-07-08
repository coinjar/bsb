# frozen_string_literal: true

require 'active_model'

class BsbNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid) unless BSB.lookup(value)
  end
end
