class Preference < ActiveRecord::Base
  def to_s
    "#{key}: #{value}"
  end
end