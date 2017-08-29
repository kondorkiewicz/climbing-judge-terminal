require_relative 'finals'

class SemiFinals < Finals
  
  def select_competitors(results)
    if results.size <= 20
      results 
    else 
      results.select do |comp| 
        comp[:place] <= list[19][:place]
      end
    end  
  end
  
end