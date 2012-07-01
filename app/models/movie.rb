class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  def self.find_movie_with_same_director(id)
    if self.find_by_id(id).director == ''
      []
    else
      self.find_all_by_director(self.find_by_id(id).director)
    end
  end
end
