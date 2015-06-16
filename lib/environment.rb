secret_path = File.expand_path("config/application.yml")

if File.exist? secret_path
  YAML::load_file(secret_path).each do |key, value|
    ENV[key] = value unless ENV.key?(key)
  end
end
