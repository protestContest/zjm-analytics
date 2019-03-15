module SettingsHelper
  def settings_pages
    [
      { name: 'profile', url: edit_registration_path(current_user) },
      { name: 'accounts', url: user_accounts_path(current_user) },
      { name: 'notifications', url: '/' }
    ]
  end
end
