Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '248066289268317', '1ff58bcd6da93f1889899b68384dfcd4',
           {
               display: 'popup',
               secure_image_url: 'true',
               image_size: 'square',
               info_fields: 'email,name,first_name,last_name,gender,age_range,birthday',
               client_options: {
                   ssl: {
                       ca_file: Rails.root.join('lib', 'assets', 'cacert.pem').to_s
                   }
               }
           }
  provider :google_oauth2, '379589292081-v7q04ljramfqbj5is5o7u641o86a98d3.apps.googleusercontent.com', 'kGNsrObFCXQtPEcfZxFPAQ4t',
           {
               name: 'google',
               prompt: 'select_account',
               image_aspect_ratio: 'square',
               image_size: 50,
               info_fields: 'email,name,first_name,last_name,gender, birthday',
               client_options: {
                   ssl: {
                       ca_file: Rails.root.join('lib', 'assets', 'cacert.pem').to_s
                   }
               }
           }
end
