module TakeSnapShotHelper
  def disable_confirm_link saintlbeau_post
    "disabled" unless saintlbeau_post
  end

  def show_error saintlbeau_post
    "show" unless saintlbeau_post
  end
end
