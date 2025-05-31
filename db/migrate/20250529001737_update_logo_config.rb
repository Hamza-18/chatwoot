class UpdateLogoConfig < ActiveRecord::Migration[7.1]
  def up
    %w[LOGO_THUMBNAIL LOGO LOGO_DARK].each do |name|
      config = InstallationConfig.find_by(name: name)
      if config
        config.serialized_value = { value: '/brand-assets/custom_logo.svg' }.with_indifferent_access
        config.save!
      end
    end

    GlobalConfig.clear_cache if defined?(GlobalConfig)
  end
end
