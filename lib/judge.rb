require_relative 'event'
require_relative 'list_manager'

class Judge
  
  attr_accessor :event 
  
  def initialize 
    @event = Event.new
    #@event.add_comps_from_file('competitors.csv')
  end
  
  def start!
    print_greetings
    manage_competitors
    el = eliminations
    if ask_for_semi_finals 
      sf = semi_finals(el)
      f = finals(sf.men, sf.women)
    else 
      puts "\nLet's head to the finals, then!\n\n"
      f = finals(el.m_res, el.f_res)
    end 
    print_goodbye(f)
  end
  
  def print_greetings
    puts "\n\n"
    puts " CLIMBING JUDGE ".center(50, '#'); puts
    puts "Hi Judge! Let's start this competitions!"
    puts "We have following competitors in our file: "; puts
    print_competitors
    puts "You want more? Or maybe you want some to be gone?"
    puts "Type 'add' to add, 'delete' to delete or 'ok' to continue."
  end
  
  def print_competitors
    puts " MEN: ".center(50, '#'); puts
    event.men.each.with_index(1) { |comp, i| puts "#{i}: #{comp}" }; puts
    puts " WOMEN: ".center(50, '#'); puts
    event.women.each.with_index(1) { |comp, i| puts "#{i}: #{comp}" }; puts
  end
  
  def manage_competitors
    answer = nil
    until answer == 'ok'
      options = ['add', 'delete', 'ok']
      p options unless options.include?(answer)
      answer = gets.strip.downcase 
      case answer 
      when 'add'
        answer = add_competitor
        print_competitors  
      when 'delete'
        answer = delete_competitor
        print_competitors  
      end 
    end 
    enough_competitors?
  end
  
  def enough_competitors?
    if event.men.size < 3 || event.women.size < 3 
      puts "\nThere are not enough competitors!"
      puts "There should be at least three in each category. Please add some more.\n\n"
      print_competitors 
      manage_competitors 
    end 
  end
  
  def add_competitor 
    puts " ADDING COMPETITOR ".center(50, '#'); puts
    name = add_name
    sex = add_sex(name)
    if event.add_comp(name, sex)
      puts "\n#{name} HAS BEEN ADDED.\n\n"
    else 
      puts "\nWE ALREADY HAVE #{name} ON OUR LIST!\n\n"
    end  
  end 
  
  def add_name
    name = nil 
    until /^\p{ALPHA}+$/ =~ name
      puts "Name should contain only letters: "
      name = gets.chomp.capitalize
    end
    name
  end
  
  def add_sex(name)
    sex = nil
    until ["M", "F"].include?(sex)
      puts "Type in sex of #{name} ('m' for male or 'f' for female) "
      sex = gets.chomp.upcase
    end 
    sex 
  end 
  
  def delete_competitor 
    puts "Insert a name of the competitor you want to delete: "
    name = gets.chomp.downcase.capitalize
    comps = event.men + event.women
    if comps.map { |comp| comp.name }.include?(name)
      event.men.delete_if { |man| man.name == name }
      event.women.delete_if { |woman| woman.name == name }
      puts "\n#{name} HAS BEEN DELETED.\n\n"
    else 
      puts "\nTHERE IS NO COMPETITOR WITH THAT NAME: (#{name})\n\n" 
    end 
  end 
  
  def eliminations 
    puts " ELIMINATIONS ".center(50, '#'); puts
    el = @event.eliminations = Eliminations.new(@event.men, @event.women)
    round('eliminations (first route)', 'men', el.m1)
    round('eliminations (first route)', 'women', el.f1)
    round('eliminations (second route)', 'men', el.m2)
    round('eliminations (second route)', 'women', el.f2)
    eliminations_results_for_men_and_women(el)
    el
  end 
  
  def round(round_name, sex, list)
    puts " #{sex.upcase}'S #{round_name.upcase}: ".center(50, '#'); puts
    ListManager.print_list(list)
    add_scores(list)
    ListManager.print_list(list)
  end
  
  def add_scores(list) 
    list.map do |comp|
      puts "Competitor: #{comp[:comp].name}"
      puts "What's his/her score?"
      add_score(comp)
    end
    ListManager.set_places(list)
    ListManager.set_ex_aequo_points(list).sort_by { |comp| comp[:place] }
  end
  
  def add_score(comp)
    score = 0
    until score =~ /^\d+$/ && score.to_i <= 50
      score = gets.chomp
      puts "Score should contain only digits!" unless score =~ /^\d+$/
      puts "Typically routes are no longer than 50 moves!" if score.to_i > 50
    end 
    ListManager.add_score(comp, score)
  end
  
  def eliminations_results_for_men_and_women(el)
    puts " ELIMINATIONS RESULTS FOR MEN: ".center(50, '#')
    ListManager.print_list(el.m_res)
    puts " ELIMINATIONS RESULTS FOR WOMEN: ".center(50, '#')
    ListManager.print_list(el.f_res)
  end
  
  def semi_finals(el) 
    puts " SEMI FINALS ".center(50, '#'); puts
    sf = event.semi_finals = SemiFinals.new(el.m_res, el.f_res)  
    round('semi finals', 'men', sf.men)
    round('semi finals', 'women', sf.women)
    puts "\nLet's head to the finals!\n\n"
    sf
  end
  
  def ask_for_semi_finals
    puts "Are we doing SEMI FINALS? Or, as always, there are not enough copetitors?"
    puts "Or maybe routesetters are too lazy to set up two more routes?"
    answer = nil
    until ['y', 'n'].include?(answer)
      puts 'Yes or no (y, n)?'
      answer = gets.chomp.downcase
    end
    answer == 'y' ? true : false
  end
  
  def finals(m_res, f_res) 
    f = event.finals = Finals.new(m_res, f_res)
    round('finals', 'men', f.men)
    round('finals', 'women', f.women)
    f
  end 
  
  def print_goodbye(f)
    puts "\nAnd now it's time for the decoration of winners!\n\n"
    suspention
    decoration('men', f.men)
    suspention 
    decoration('women', f.women)
    puts "\nThanks for all spectators and competitors!"
    puts "And see you on the next one!!!"
  end 
  
  def decoration(sex, comps)
    puts "\nIn #{sex}'s category...\n\n"
    suspention 
    medals(comps)
  end
  
  def medals(comps) 
    comps.first(3).each do |comp|
      medal = case comp[:place]
      when 1
        'Gold'
      when 2
        'Silver'
      when 3 
        'Bronze'
      end
      puts "\n#{medal} medal goes to...\n\n"
      suspention 
      puts "\n#{comp[:comp].name}!!!\n\n" 
    end
  end
  
  def suspention
    3.times { sleep(1); print '.'}
    puts 
  end
  
end