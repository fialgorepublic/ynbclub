module TakeSnapShotHelper
  def disable_confirm_link saintlbeau_post
    "disabled" unless saintlbeau_post
  end

  def show_error saintlbeau_post
    "show" unless saintlbeau_post
  end

  def snapshot_banner_url page
    page.snapshot_banner.attached? ? page.snapshot_banner : "/assets/user-img-2.png"
  end

  def snapshot_banner_name page
    page.snapshot_banner.attached? ? page.snapshot_banner.filename : "No file Chosen"
  end
end
