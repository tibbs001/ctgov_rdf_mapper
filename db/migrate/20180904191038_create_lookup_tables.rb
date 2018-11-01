class CreateLookupTables < ActiveRecord::Migration[4.2]

  def change

    create_table "countries", force: :cascade do |t|
      t.string "iso"
      t.string "qid"
      t.string "osm_relid"
      t.string "label"
    end

    create_table "facilities", force: :cascade do |t|
      t.string "iso"
      t.string "quid"
      t.string "label"
    end
  end

end
