class AddDirectorToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :director, :string, {:default=>"N/A"}
  end
end
