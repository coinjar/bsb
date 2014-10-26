require 'bsb'
require 'active_model'

class BSBNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless BSB.lookup(value)
      record.errors.add(attribute, options[:message] || :invalid)
    end
  end
end
