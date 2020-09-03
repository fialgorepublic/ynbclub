Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '592199631473385', 'aa852d87d61d6f2fae451d8fab4a674d'
  
           {
               display: 'popup',
               secure_image_url: 'false',
               image_size: 'square',
               image_size: {width: 512, height: 512},
               info_fields: 'email,name,first_name,last_name,gender,age_range,birthday',
               client_options: {
                   ssl: {
                       ca_file: Rails.root.join('lib', 'assets', 'cacert.pem').to_s
                   }
               }
           }
  provider :google_oauth2, '555781400009-hr0q2gr71orj6hf8omqm67h1hlic5m9p.apps.googleusercontent.com', 'NPsn0Tryzl1TE1BmbkxcxlRq',
           {
               name: 'google',
               prompt: 'select_account',
               image_aspect_ratio: 'square',
               image_size: 512,
               info_fields: 'email,name,first_name,last_name,gender, birthday',
               client_options: {
                   ssl: {
                       ca_file: Rails.root.join('lib', 'assets', 'cacert.pem').to_s
                   }
               }
           }
end
