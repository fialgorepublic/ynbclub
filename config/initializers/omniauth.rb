Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '164286157812635', 'aca44f48809b3604ca6075f31fcde0e8'
  
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
  provider :google_oauth2, '331326190192-hd1hs5sm6aec0aci26lp277ukvrr6ve9.apps.googleusercontent.com', 'lZOamR_focsB1TEofAYnSaIG',
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
