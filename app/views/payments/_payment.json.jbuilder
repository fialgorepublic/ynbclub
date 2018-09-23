json.extract! payment, :id, :payment_code, :payment_date, :amount, :recipient_name, :email, :number_math, :status, :note, :created_at, :updated_at
json.url payment_url(payment, format: :json)
