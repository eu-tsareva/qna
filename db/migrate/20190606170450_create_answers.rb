class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.belongs_to :question, foreign_key: true
      t.text :body
      t.boolean :best, default: false

      t.timestamps
    end
  end
end
