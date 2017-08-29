module ListManager
  extend self
  
  def add_score(comp, score)
    comp[:score] = score.to_i
  end
  
  def print_list(list) 
    columns_names = list.first.keys.map { |key| key.to_s.upcase }
    puts "\n\n"
    columns_names.each { |name| print name.center(12) }; puts
    list.each do |comp|
      comp.values.each { |v| print v.to_s.center(12) }; puts
    end
    puts "\n\n"
  end
  
  def set_places(scores)
    scores.sort_by! {|score| score[:score]}.reverse!
    count = 1; place = 1
    scores.each_cons(2) do |a, b|
      if a[:score] == b[:score]
        a[:place] = place; b[:place] = place
        count += 1
      else 
        a[:place] = place; b[:place] = place + count
        place += count; count = 1
      end 
    end 
    scores
  end
  
  def set_ex_aequo_points(list)
    ex_aequo_places = list.group_by {|comp| comp[:place]}
    ex_aequo_places.map do |place, comps|
      if comps.size > 1
        add_ex_aequo_points(place, comps)
      else 
        comps.each {|comp| comp[:points] = comp[:place]}
      end 
    end
    list
  end
  
  def add_ex_aequo_points(place, comps)
    limit = place + comps.size - 1
    range = place < limit ? place..limit : limit..place 
    points = [*range].inject(:+) / comps.size.to_f
    comps.each do |comp|
      comp[:points] = points 
    end 
  end 
  
end