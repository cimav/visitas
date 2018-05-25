json.extract! room_visit, :id, :date, :status, :visit_id, :room_id, :persona_id, :created_at, :updated_at
json.url room_visit_url(room_visit, format: :json)
