class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.string :name
      t.belongs_to :book, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
