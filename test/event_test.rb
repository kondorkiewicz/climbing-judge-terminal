require 'minitest/autorun'
require_relative '../lib/event.rb'

class EventTest < Minitest::Test
  
  def setup 
    @event = Event.new
    @path = File.dirname(File.expand_path(__FILE__)) + '/competitors_test.csv'
  end
  
  def test_with_new_event_mens_list_is_empty
    assert_equal 0, @event.men.size
  end
  
  def test_with_new_event_womens_list_is_empty
    assert_equal 0, @event.women.size
  end
  
  def test_you_can_add_one_competitor
    @event.add_comp('Jacek', 'M')
    assert_equal 1, @event.men.size
  end
  
  def test_you_can_add_men_from_file
    @event.add_comps_from_file(@path)
    assert_equal 5, @event.men.size
  end
  
  def test_you_can_add_women_from_file
    @event.add_comps_from_file(@path)
    assert_equal 6, @event.women.size
  end
  

  
end 