OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '329106027192639', '65e36365a10319915caeeea49b52463e'
end