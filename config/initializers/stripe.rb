
begin
  myFile=File.open("/home/pm/keys.txt","r")
  line1=myFile.gets
  line2=myFile.gets
rescue
  line1='bad'
  line2='bad'
end





Rails.configuration.stripe = {
  :publishable_key => line1.strip,
  :secret_key      => line2.strip


}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
