class CreateSolidQueueSemaphores < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_queue_semaphores do |t|
      t.string :key, null: false
      t.integer :value, default: 1, null: false
      t.datetime :expires_at, null: false
      t.timestamps null: false
    end

    add_index :solid_queue_semaphores, :expires_at
    add_index :solid_queue_semaphores, [:key, :value]
    add_index :solid_queue_semaphores, :key, unique: true
  end
end
