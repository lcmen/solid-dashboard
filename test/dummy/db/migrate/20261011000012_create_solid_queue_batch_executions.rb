class CreateSolidQueueBatchExecutions < ActiveRecord::Migration[8.1]
  def change
    create_table :solid_queue_batch_executions do |t|
      t.bigint :job_id, null: false
      t.bigint :batch_id, null: false
      t.datetime :created_at, null: false
    end

    add_index :solid_queue_batch_executions, :job_id, unique: true
    add_index :solid_queue_batch_executions, :batch_id
    add_foreign_key :solid_queue_batch_executions, :solid_queue_jobs, column: :job_id, on_delete: :cascade
    add_foreign_key :solid_queue_batch_executions, :solid_queue_batches, column: :batch_id, on_delete: :cascade
  end
end
