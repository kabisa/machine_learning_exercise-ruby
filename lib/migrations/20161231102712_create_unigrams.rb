class CreateUnigrams < ActiveRecord::Migration[5.0]
  def up
    create_table :unigrams do |t|
      t.string :word
      t.string :klass
      t.integer :count
    end

    add_index :unigrams, [:word, :klass], unique: true
  end
end
