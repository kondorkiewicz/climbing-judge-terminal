require 'minitest/autorun'
require_relative '../lib/event'
require_relative '../lib/list_manager'

class EliminationsTest < Minitest::Test 
  
  def setup
    @event = Event.new
    path = File.dirname(File.expand_path(__FILE__)) + '/competitors_test.csv'
    @event.add_comps_from_file(path) 
    @el = @event.eliminations = Eliminations.new(@event.men, @event.women)
  end 
  
  def add_to_list(list, smth, arr)
    list.each.with_index { |comp, i| comp[smth.to_sym] = arr[i] }
  end
  
  ############################# LISTS #########################################
  
  def test_there_are_all_men_on_the_first_list
    assert_equal @event.men.size, @el.m1.size
  end
  
  def test_there_are_all_women_on_the_first_list
    assert_equal @event.women.size, @el.f1.size
  end
  
  def test_both_lists_for_men_are_equal_in_size
    assert_equal @el.m1.size, @el.m2.size
  end
  
  def test_both_lists_for_women_are_equal_in_size
    assert_equal @el.f1.size, @el.f2.size
  end
  
  def test_both_lists_for_men_are_not_equal
    refute_equal @el.m1, @el.m2
  end
  
  def test_both_lists_for_women_are_not_equal
    refute_equal @el.f1, @el.f2
  end
  
  ########################## START NUMBERS ####################################
  
  def test_all_start_numbers_on_first_list_are_added
    start_numbers = @el.m1.map {|comp| comp[:start_num]}
    assert_equal [1, 2, 3, 4, 5], start_numbers
  end
  
  def test_all_start_numbers_on_second_list_are_added
    start_numbers = @el.m2.map {|comp| comp[:start_num]}
    assert_equal [1, 2, 3, 4, 5], start_numbers
  end
  
  def test_male_from_first_list_is_on_a_proper_place_on_second_list
    assert_equal @el.m1[0][:comp], @el.m2[3][:comp]
  end
  
  def test_female_from_first_list_is_on_a_proper_place_on_second_list
    assert_equal @el.f1[0][:comp], @el.f2[3][:comp]
  end
  
  def test_start_numbers_on_both_lists_are_added_properly_with_odd_number_of_competitors
    assert_equal [1, 4], [@el.m1[0][:start_num], @el.m2[3][:start_num]]
  end
  
  def test_start_numbers_on_both_lists_are_added_properly_with_even_number_of_competitors
    assert_equal [1, 4], [@el.f1[0][:start_num], @el.f2[3][:start_num]]
  end

################## SET POINTS AFTER TWO ELIMINATIONS ROUNDS ###################

def test_all_first_places_on_both_routes
  add_to_list(@el.m1, 'points', [1, 1, 1, 1, 1]); add_to_list(@el.m2, 'points', [1, 1, 1, 1, 1])
  points = @el.set_points(@el.m1, @el.m2).map { |comp| comp[:points] }
  assert_equal [1.41, 1.41, 1.41, 1.41, 1.41], points
end

def test_all_same_places_on_both_routes
  add_to_list(@el.m1, 'points', [1, 2, 3, 4, 5]); add_to_list(@el.m2, 'points', [3, 4, 5, 1, 2])
  points = @el.set_points(@el.m1, @el.m2).map { |comp| comp[:points] }
  assert_equal [1.41, 2.0, 2.45, 2.83, 3.16], points
end

def test_different_places_on_both_routes
  add_to_list(@el.m1, 'points', [1, 2, 3, 4, 5]); add_to_list(@el.m2, 'points', [1, 2, 3, 4, 5])
  points = @el.set_points(@el.m1, @el.m2).map { |comp| comp[:points] }
  assert_equal [2.0, 2.24, 2.45, 2.65, 2.83], points
end

################## SET PLACES AFTER TWO ELIMINATIONS ROUNDS ###################

def test_all_first_places_on_both_routes_give_all_first_places
  add_to_list(@el.m1, 'place', [1, 1, 1, 1, 1]); add_to_list(@el.m2, 'place', [1, 1, 1, 1, 1])
  ListManager.set_ex_aequo_points(@el.m1); ListManager.set_ex_aequo_points(@el.m2)
  places = @el.m_res.map { |comp| comp[:place] }
  assert_equal [1, 1, 1, 1, 1], places
end

def test_all_same_places_on_both_routes_give_different_places
  add_to_list(@el.m1, 'place', [1, 2, 3, 4, 5]); add_to_list(@el.m2, 'place', [3, 4, 5, 1, 2])
  ListManager.set_ex_aequo_points(@el.m1); ListManager.set_ex_aequo_points(@el.m2)
  places = @el.m_res.map { |comp| comp[:place] }
  assert_equal [1, 2, 3, 4, 5], places
end

def test_reversed_places_after_eliminations_give_all_first_places
  add_to_list(@el.m1, 'place', [1, 2, 3, 4, 5]); add_to_list(@el.m2, 'place', [3, 2, 1, 5, 4])
  ListManager.set_ex_aequo_points(@el.m1); ListManager.set_ex_aequo_points(@el.m2)
  places = @el.m_res.map { |comp| comp[:place] }
  assert_equal [1, 1, 1, 1, 1], places
end 

def test_two_first_and_two_third_places
  add_to_list(@el.m1, 'place', [1, 2, 3, 4, 5]); add_to_list(@el.m2, 'place', [4, 3, 5, 2, 1])
  ListManager.set_ex_aequo_points(@el.m1); ListManager.set_ex_aequo_points(@el.m2)
  places = @el.m_res.map { |comp| comp[:place] }
  assert_equal [1, 1, 3, 3, 5], places
end 
  
    
end