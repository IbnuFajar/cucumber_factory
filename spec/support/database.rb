Gemika::Database.new.rewrite_schema! do

  create_table :movies do |t|
    t.string :title
    t.integer :year
    t.integer :prequel_id
    t.integer :reviewer_id
    t.integer :box_office_result
  end

  create_table :users do |t|
    t.string :email
    t.string :name
    t.boolean :deleted
    t.boolean :locked
    t.boolean :subscribed
    t.boolean :scared
    t.boolean :scared_by_spiders
    t.datetime :created_at
  end

  create_table :payments do |t|
    t.text :comment
    t.integer :amount
  end

  create_table :actors do |t|
  end

end
