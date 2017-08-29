class Eliminations 
  
  attr_accessor :m1, :m2, :f1, :f2
  
  def initialize(men, women) 
    @m1 = make_first_list(men)
    @f1 = make_first_list(women) 
    @m2 = make_second_list(@m1)
    @f2 = make_second_list(@f1)
  end
  
  def m_res 
    @m_res = set_places_after_eliminations(@m1, @m2)
  end
  
  def f_res 
    @f_res = set_places_after_eliminations(@f1, @f2)
  end
  
  def make_first_list(comps)
    comps.shuffle!
    comps.each.with_index(1).map do |comp, i|
      { start_num: i, comp: comp }
    end
  end 
  
  def make_second_list(first_list)
    second_list = []
    half = first_list.size / 2 + 1
    first_list.size.even? ? start_num = half : start_num = half + 1 
    first_list.each.with_index(1) do |comp, i|
      start_num = 1 if i == half
      second_list << { start_num: start_num, comp: comp[:comp] }
      start_num += 1 
    end
    second_list.sort_by { |comp| comp[:start_num] }
  end 
  
  def set_places_after_eliminations(el1_res, el2_res)
    points = set_points(el1_res, el2_res)
    set_places(points)
  end
  
  def set_points(el1_res, el2_res)
    list = []
    sum_of_lists = el1_res + el2_res
    el_scores = sum_of_lists.group_by { |comp| comp[:comp] }
    el_scores.map do |comp, scores|
      scores.each_cons(2) do |a, b|
        list << { comp: comp, points: Math.sqrt(a[:points] + b[:points]).round(2) }
      end
    end
    list.sort_by { |comp| comp[:points] }
  end
  
  def set_places(list)
    list.sort_by! { |comp| comp[:points] }
    count = 1; place = 1
    list.each_cons(2) do |comp1, comp2|
      if comp1[:points] == comp2[:points]
        comp1[:place] = place; comp2[:place] = place
        count += 1
      else 
        comp1[:place] = place; comp2[:place] = place + count
        place += count; count = 1
      end 
    end 
    list
  end
  
end 