OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2,'394751805133-82rq3h2eicpu89f9jni2bl377f9icap6.apps.googleusercontent.com', 'Qr2i9Mm9TNILAKxoaPDLPjzB',
           { :scope => 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile'}
           {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s, verify: false}}}
end



=begin This is for the production-server
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2,'1066313403274-qjrvn9ef31sin272o7du0var377jet5j.apps.googleusercontent.com', 'uXI8yKOWYDtCJ70TZRqTRVz5',
           { :scope => 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile'}
           {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s, verify: false}}}
end
=end

