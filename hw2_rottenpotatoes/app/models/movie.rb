class Movie < ActiveRecord::Base
  def self.my_all_rate
     self.select(:rating).map {|r| r.rating}.uniq.sort
  end
end
