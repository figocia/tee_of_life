require 'pathname'

class TreeOfLife
  def initialize(path)
    self.files = %x[find '#{path}' -name '*.life'].split("\n")
    self.lifes = Array.new
    files.each{|file| lifes << file_to_obj(file)}    
  end

  class Life
    attr_accessor :species, :name, :eats, :move, :group
    def initialize(hash)
      self.species, self.name, self.eats, self.move, self.group = hash[:species], hash[:name], 
                                                                  hash[:eats], hash[:move], hash[:group]
    end
  end

  # def in_group(group)
  #   return [] if group.nil? || group == ''
  #   matching_files = files.select{ |file| file.downcase.split('/').include?(group.downcase) }
  #   matching_files.map{|file| file_to_hash(file)}
  # end

  def in_group(group)
    return [] if group.nil?
    lifes.select{|life| life.group.include?(group.downcase)}
    
  end

  def all_that_eat(food)
    return [] if food.nil? || food == ''
    files.map{|file| file_to_hash(file)}.select{|hash| hash[:eats].downcase == food.downcase}
  end

  def exercise_those_that(move)
    return '' if move.nil? || move == ''
    matching_hashes = files.map{|file| file_to_hash(file)}.select{|hash| hash[:move].downcase == move.downcase}
    case move.downcase
    when 'fly'
      headline = 'Look in the sky!'
      action = 'flies'
    when 'scuttle'
      headline = 'Look on the ground!'
      action = 'scuttles'
    when 'swim'
      headline = 'Look in the water!'
      action = 'swims'
    else
      headline = "There are no life forms that #{move}"
    end
    "#{headline}\n#{matching_hashes.map{|hash| 'The ' + hash[:name] + ' ' + action}.join("\n")}"
  end

  def describe(species)
    return '' if species.nil? || species == ''
    match = files.map{|file| file_to_hash(file)}.find{|hash| hash[:species].downcase == species.downcase}
    if match.nil?
      "The species #{species} does not exist"
    else
      case match[:move].downcase
      when 'fly'
        action = 'flies'
      when 'scuttle'
        action = 'scuttles'
      when 'swim'
        action = 'swims'
      end
      "The #{match[:name]} (#{match[:species]}) eats #{match[:eats].downcase}" \
        " and #{action}"
    end
  end

  private

  attr_accessor :files, :lifes

  def file_to_hash(file)
    # require 'pry'; binding.pry
    contents = File.read(file).split("\n")
    {
      
      species: File.basename(file).gsub('.life', '').gsub('_', ' '),
      name: contents[0].gsub('Name: ', ''),
      eats: contents[1].gsub('Eats: ', ''),
      move: contents[2].gsub('Move: ', '')
    }
  end

  def file_to_obj(file)
    # require 'pry'; binding.pry
    contents = File.read(file).split("\n")
    TreeOfLife::Life.new({
      species: File.basename(file).gsub('.life', '').gsub('_', ' '),
      name: contents[0].gsub('Name: ', ''),
      eats: contents[1].gsub('Eats: ', ''),
      move: contents[2].gsub('Move: ', ''),
      group: file.downcase.split('/') }
    )
  end
end
