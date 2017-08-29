require 'minitest/autorun'
require_relative '../lib/list_manager'
require_relative '../lib/competitor'
require_relative '../lib/eliminations'

class ListManagerTest < Minitest::Test
  
  def setup 
    comps = {
      'M' => ['Konrad', 'Wojtek', 'Marcin', 'Maciej', 'Karol'],
      'W' => ['Maja', 'Ida', 'Olga', 'Kinga', 'Bożena']
    }
    
    @el = Eliminations.new(*add_comps(comps))
  end
  
  def add_comps(comps)
    competitors = [[], []]; index = 0
    comps.each do | sex,names | 
      names.each do |name|
        competitors[index] << Competitor.new(name, sex)
      end 
      index = 1
    end
    competitors
  end 
  
  def add_scores(list, scores) 
    list.each.with_index { |comp, i| ListManager.add_score(comp, scores[i]) }
  end
  
  ############################# SET PLACES ####################################
  
  def test_different_scores_give_different_places 
    scores = add_scores(@el.m1, [34, 32, 26, 25, 24])
    results = ListManager.set_places(scores).map { |score| score[:place] }
    assert_equal [1, 2, 3, 4, 5], results
  end
  
  def test_different_scores_in_random_order_give_different_places
    scores = add_scores(@el.m1, [34, 32, 26, 25, 24].shuffle!)
    results = ListManager.set_places(scores).map {|score| score[:place]}
    assert_equal [1, 2, 3, 4, 5], results
  end
  
  def test_all_the_same_scores_give_all_first_places
    scores = add_scores(@el.m1, [21, 21, 21, 21, 21])
    results = ListManager.set_places(scores).map {|score| score[:place]}
    assert_equal [1, 1, 1, 1, 1], results
  end 
  
  def test_same_scores_give_same_places
    scores = add_scores(@el.m1, [34, 22, 22, 22, 21])
    results = ListManager.set_places(scores).map {|score| score[:place]}
    assert_equal [1, 2, 2, 2, 5], results
  end 
  
  ######################### SET EX-AEQUO POINTS ##############################
  
  def test_five_people_on_first_place_give_3_points
    scores = add_scores(@el.m2, [21, 21, 21, 21, 21])
    results = ListManager.set_places(scores)
    points = ListManager.set_ex_aequo_points(results).map {|result| result[:points]}
    assert_equal [3.0, 3.0, 3.0, 3.0, 3.0], points
  end
  
  def test_four_people_on_second_place_give_3_5_points
    scores = add_scores(@el.m2, [30, 21, 21, 21, 21])
    results = ListManager.set_places(scores)
    points = ListManager.set_ex_aequo_points(results).map {|result| result[:points]}
    assert_equal [1, 3.5, 3.5, 3.5, 3.5], points
  end
  
  def test_three_first_places_and_two_fourth_places_give
    scores = add_scores(@el.m2, [22, 22, 22, 21, 21])
    results = ListManager.set_places(scores)
    points = ListManager.set_ex_aequo_points(results).map {|result| result[:points]}
    assert_equal [2.0, 2.0, 2.0, 4.5, 4.5], points
  end
  
end