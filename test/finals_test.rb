require 'minitest/autorun'
require_relative '../lib/event.rb'

class FinalsTest < Minitest::Test 
  
  def setup 
    @e = Event.new 
    @placeholder = [ { place: 1 } ]
  end
  
  def test_8_different_places_give_8_finalists
    m_list = %w(1 2 3 4 5 6 7 8 9 10).map { |place| {place: place.to_i} }
    @f = Finals.new(m_list, @placeholder)
    assert_equal 8, @f.men.size
  end 
  
  def test_7_same_places_and_one_eighth_give_8_finalists
    m_list = %w(1 1 1 1 1 1 1 8 9 10).map { |place| {place: place.to_i} }
    @f = Finals.new(m_list, @placeholder)
    assert_equal 8, @f.men.size
  end
  
  def test_3_eighth_places_give_10_finalists
    m_list = %w(1 1 1 1 1 1 1 8 8 8).map { |place| {place: place.to_i} }
    @f = Finals.new(m_list, @placeholder)
    assert_equal 10, @f.men.size
  end
  
  def test_2_eighth_places_give_9_finalists
    m_list = %w(1 1 1 1 1 1 1 8 8 10).map { |place| {place: place.to_i} }
    @f = Finals.new(m_list, @placeholder)
    assert_equal 9, @f.men.size
  end
  
  
end