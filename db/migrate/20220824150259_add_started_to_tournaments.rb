class AddStartedToTournaments < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :started, :boolean, default: false
  end
end
