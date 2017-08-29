require_relative 'competitor'
require_relative 'eliminations'
require_relative 'semi_finals'
require_relative 'finals'


class Event 
  
  attr_accessor :men, :women, :eliminations, :semi_finals, :finals 
  
  def initialize
    @men = []; @women = []
    @eliminations = nil; @semi_finals = nil; @finals = nil
  end 
  
  def add_comp(name, sex)
    comp = Competitor.new(name, sex)
    comps = @men + @women 
    comps.include?(comp) ? false : add_by_sex(comp)
  end
  
  def add_by_sex(comp)
    comp.sex == "M" ? @men << comp : @women << comp
  end
  
  def add_comps_from_file(path)
    comps = []
    File.foreach(path) do |line| 
      args = line.chomp.split(',')
      comp = Competitor.new(args[0], args[1])
      comps << comp unless comps.include?(comp)
    end
    @men, @women = divide_by_sex(comps)
  end
  
  def divide_by_sex(comps)
    comps.partition {|comp| comp.sex == "M"}
  end
  
  
end