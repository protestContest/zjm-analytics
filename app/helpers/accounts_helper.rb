module AccountsHelper
  def row_toggle_selector account
    if account.new_record?
      return "#account-row-new,#account-row-new + .box-list__row"
    else
      return "#account-row-#{account.id},#account-row-#{account.id} + .box-list__row"
    end
  end
end
