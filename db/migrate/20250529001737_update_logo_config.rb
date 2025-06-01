class UpdateLogoConfig < ActiveRecord::Migration[7.1]
  def up
    # Update the logo configurations to point to the new custom logo path
    %w[LOGO_THUMBNAIL LOGO LOGO_DARK].each do |name|
      config = InstallationConfig.find_by(name: name)
      next unless config

      # Update the serialized value to point to the new custom logo path using with_indifferent_access
      config.serialized_value = { value: '/brand-assets/custom_logo.svg' }.with_indifferent_access
      config.save!
    end

    GlobalConfig.clear_cache if defined?(GlobalConfig)
  end
end
