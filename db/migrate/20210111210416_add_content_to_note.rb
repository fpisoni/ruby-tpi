class AddContentToNote < ActiveRecord::Migration[6.1]
  def change
    change_table :notes do |t|
      t.text :content
    end
  end
end
