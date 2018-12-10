module PaymentsHelper
  def selected_since_date params
    params[:search].present? ? params[:search][:start_date] : nil
  end

  def selected_to_date params
    params[:search].present? ? params[:search][:to_date] : nil
  end

  def selected_partner params
    params[:search].present? ? params[:search][:partner] : nil
  end
end
