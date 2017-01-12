class CreateTweets < ActiveRecord::Migration[5.0]
  def up
    create_table :tweets do |t|
      t.string :text
      t.string :klass
      t.string :correlation_id
    end

    add_index :tweets, :correlation_id, unique: true
  end
end
