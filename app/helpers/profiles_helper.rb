module ProfilesHelper

  def states
    states = CS.states(:VN).to_a
    states = states.map{ |state|
      state[1]
    }
    return states.sort
  end

  def cities
    cities = CS.states(:VN).keys.flat_map { |state| CS.cities(state, :VN) }
    return cities.sort
  end

end
