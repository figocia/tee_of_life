require 'pathname'

class TreeOfLife
  
  def initialize(path)
    self.files = %x[find '#{path}' -name '*.life'].split("\n")
    self.lifes = Array.new
    files.each{|file| lifes << file_to_obj(file)}    
  end

  def in_group(group)
    return [] if group.nil? || group == ''
    lifes.select{|life| life.group.include?(group.downcase)}    
  end

  def all_that_eat(food)
    return [] if food.nil? || food == ''
    lifes.select{|life| life.eats.downcase == food.downcase }
  end


  def exercise_those_that(move)
    return '' if move.nil? || move == ''
    move_lifes = lifes.select{|life| life.move.downcase == move.downcase}
    
    case move.downcase
    when 'fly'
      headline = 'Look in the sky!'
    when 'scuttle'
      headline = 'Look on the ground!'
    when 'swim'
      headline = 'Look in the water!'
    else
      headline = "There are no life forms that #{move}"
    end
    "#{headline}\n#{move_lifes.map(&:exercise).join('\n')}"
  end

  def describe(species)
    return '' if species.nil? || species == ''
    match = lifes.detect{|life| life.species.downcase == species.downcase }
    if match.nil?
      "The species #{species} does not exist"
    else
      match.describe_species
    end
  end


    # Encapsulation and Single responsibility
  class Life
    attr_accessor :species, :name, :eats, :move, :group
    
    def initialize(hash)
      self.species, self.name, self.eats, self.move, self.group = hash[:species], hash[:name], 
                                                                  hash[:eats], hash[:move], hash[:group]
    end

    def exercise
      "The #{name} #{action}"  
    end

    def action
      case move.downcase
      when 'fly'
        action = 'flies'
      when 'scuttle'
        action = 'scuttles'
      when 'swim'
        action = 'swims'
      end
    end

    def describe_species
      "The #{name} (#{species}) eats #{eats.downcase}" \
        " and #{action}"
    end
  end


  private

  attr_accessor :files, :lifes

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
