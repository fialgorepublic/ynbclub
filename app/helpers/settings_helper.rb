module SettingsHelper
  def get_province name
    return nil if name.blank?
    state = State.find_by_name(name)
    state.present? ? state.name : nil
  end

  def get_city name
    return nil if name.blank?
    city = City.find_by_name(name)
    city.present? ? city.name : nil
  end
end
