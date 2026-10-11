class CreateSolidQueuePauses < ActiveRecord::Migration[8.1]
  def change
    create_table :solid_queue_pauses do |t|
      t.string :queue_name, null: false
      t.datetime :created_at, null: false
    end

    add_index :solid_queue_pauses, :queue_name, unique: true
  end
end
