module SettingsHelper
  def settings_pages
    [
      { name: 'profile', url: '/' },
      { name: 'accounts', url: '/' },
      { name: 'notifications', url: '/' }
    ]
  end
end
