class CreateSolidQueueReadyExecutions < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_queue_ready_executions do |t|
      t.bigint :job_id, null: false
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.datetime :created_at, null: false
    end

    add_index :solid_queue_ready_executions, :job_id, unique: true
    add_index :solid_queue_ready_executions, [:priority, :job_id], name: "index_solid_queue_poll_all"
    add_index :solid_queue_ready_executions, [:queue_name, :priority, :job_id], name: "index_solid_queue_poll_by_queue"
    add_foreign_key :solid_queue_ready_executions, :solid_queue_jobs, column: :job_id, on_delete: :cascade
  end
end
