class CreateBlogs < ActiveRecord::Migration[8.0]
  def change
    create_table :blogs do |t|
      t.string :title, null: false
      t.string :slug, index: { unique: true }
      t.text :description
      t.text :short_description
      t.string :thumbnail
      t.text :gallery
      t.references :user, null: false
      t.references :category, null: false
      t.boolean :published, default: false
      t.datetime :published_at
      t.timestamps
    end
  end
end
