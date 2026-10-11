class CreateSolidQueueRecurringExecutions < ActiveRecord::Migration[8.1]
  def change
    create_table :solid_queue_recurring_executions do |t|
      t.bigint :job_id, null: false
      t.string :task_key, null: false
      t.datetime :run_at, null: false
      t.datetime :created_at, null: false
    end

    add_index :solid_queue_recurring_executions, :job_id, unique: true
    add_index :solid_queue_recurring_executions, [:task_key, :run_at], unique: true
    add_foreign_key :solid_queue_recurring_executions, :solid_queue_jobs, column: :job_id, on_delete: :cascade
  end
end
