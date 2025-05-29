class UpdateLogoConfig < ActiveRecord::Migration[7.1]
  def up
    config = InstallationConfig.find_by(name: 'LOGO_THUMBNAIL')
    if config
      config.value = { value: '/brand-assets/custom_logo.svg' }
      config.save!
    end

    GlobalConfig.clear_cache if defined?(GlobalConfig)
  end

  def up
    config = InstallationConfig.find_by(name: 'LOGO')
    if config
      config.value = { value: '/brand-assets/custom_logo.svg' }
      config.save!
    end

    GlobalConfig.clear_cache if defined?(GlobalConfig)
  end

  def up
    config = InstallationConfig.find_by(name: 'LOGO_DARK')
    if config
      config.value = { value: '/brand-assets/custom_logo.svg' }
      config.save!
    end
    GlobalConfig.clear_cache if defined?(GlobalConfig)
  end
end
