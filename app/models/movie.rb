class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  def find_movie_with_same_director(dir)
    self.find_by_director(dir)
  end
end
