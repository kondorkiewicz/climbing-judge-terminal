class Finals 
  
  attr_accessor :men, :women 
  
  def initialize(m_list, f_list)
    @men = make_list(m_list)
    @women = make_list(f_list)
  end
  
  def make_list(results)
    comps = select_competitors(results)
    set_starting_numbers(comps)
  end
  
  def select_competitors(results)
    if results.size <= 8
      results 
    else 
      results.select do |comp| 
        comp[:place] <= results[7][:place]
      end
    end  
  end
  
  def set_starting_numbers(comps)
    comps.sort_by! { |comp| comp[:place] }.reverse!
    comps.each.with_index(1) do |comp, i| 
      comp.delete(:points); comp.delete(:place)
      comp[:start_num] = i
    end
  end
  
  
end