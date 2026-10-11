class CreateSolidQueueBatches < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_queue_batches do |t|
      t.string :active_job_batch_id
      t.string :description
      t.text :on_finish
      t.text :on_success
      t.text :on_failure
      t.text :metadata
      t.integer :total_jobs, default: 0, null: false
      t.integer :completed_jobs, default: 0, null: false
      t.integer :failed_jobs, default: 0, null: false
      t.datetime :enqueued_at
      t.datetime :finished_at
      t.datetime :failed_at
      t.timestamps null: false
    end

    add_index :solid_queue_batches, :active_job_batch_id, unique: true
    add_index :solid_queue_batches, :finished_at
  end
end
