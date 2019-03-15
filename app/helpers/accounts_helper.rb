module AccountsHelper
  def row_toggle_selector account
    "#account-row-#{account.id},#account-row-#{account.id} + .box-list__row"
  end
end
