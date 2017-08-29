class Competitor 
  
  attr_accessor :name, :sex
  
  def initialize(name, sex)
    @name = name
    @sex = sex
  end
  
  def save_in_file(path)
    File.open(path, 'a') {|file| file.puts "#{name},#{sex}"}
  end
  
  def to_s 
    "#{@name}"
  end
  
  def ==(other)
    other.name == name && other.sex == sex
  end

end 