class CreateSolidQueueProcesses < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_queue_processes do |t|
      t.string :kind, null: false
      t.datetime :last_heartbeat_at, null: false
      t.bigint :supervisor_id
      t.integer :pid, null: false
      t.string :hostname
      t.text :metadata
      t.datetime :created_at, null: false
      t.string :name, null: false
    end

    add_index :solid_queue_processes, :last_heartbeat_at
    add_index :solid_queue_processes, [:name, :supervisor_id], unique: true
    add_index :solid_queue_processes, :supervisor_id
  end
end
