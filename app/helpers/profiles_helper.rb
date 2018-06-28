module ProfilesHelper

  def states
    states = CS.states(:TH).to_a
    states = states.map{ |state|
      state[1]
    }
    return states.sort
  end

  def cities
    cities = CS.states(:th).keys.flat_map { |state| CS.cities(state, :th) }
    return cities.sort
  end

end
