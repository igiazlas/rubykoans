# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

class DiceSet
  attr_reader :values

  def roll(t)
    @values = Array.new
    t.times { @values << Random.rand(1..6) }
    @values
  end
end

class Player
  attr_reader :name
  attr_accessor :score

  def initialize(name="anon")
    @name = name
    @score = 0
  end

  def play_round
    puts "#{@name} is playing a round"
    dice = DiceSet.new
    r = dice.roll(5)
    puts "#{@name} rolled (#{r.join(", ")})"
    return r
  end
end

class Game
  def initialize(*players)
    @players = players
  end

  def play_rounds(no_of_rounds)
    no_of_rounds.times { game_round }
    @players.each {|p| puts "#{p.name}:\t#{p.score}"}
    @players = @players.sort { |p_p, c_p| c_p.score <=> p_p.score }
    winner = @players[0]
    puts "\n#{winner.name} is the WINNER!!!\n\n"

    return winner
  end

  private def game_round
    puts "Round starts\n=================\n\n"
    @players.each do |p|
      roll = p.play_round
      score = calc_score(roll)
      p.score += score
      puts "#{p.name} scored #{score}\n\n"
    end
    puts "Round Over\n\n"
  end

  private def calc_score(dice)
    # You need to write this method

    # If the roll has more than 5 or less than 1 dice the score is 0
    unless dice.length > 0 && dice.length <= 5
      return 0
    end

    # A map of the dice numbers and the times the dice came up in the roll
    dice_map = {:"1" => 0, :"2" => 0, :"3" => 0, :"4" => 0, :"5" => 0, :"6" => 0}
    # Filter out the impossible dice numbers
    dice = dice.find_all { |d| d >= 1 && d <= 6 }
    # Count the times each dice came up
    dice.each { |d| dice_map[d.to_s.to_sym] += 1 }

    s = 0

    dice_map.each_pair do |key, cnt|
      case key
      when :"1"
        # Score for the three ones
        if cnt >= 3
          s += 1000
          cnt -= 3
        end
        # and any additional ones after the three
        cnt.times { s += 100 }
      when :"5"
        # Score for the three fives
        if cnt >= 3
          s += 500
          cnt -= 3
        end
        # and any additional ones
        cnt.times { s += 50 }
      else
        # Calculate the dice's value from the key
        # and if it came more than 3 times
        # add its value x 100 to the score
        # We can't have more than 3 trios because we have 5 dice
        s += key.to_s.to_i * 100 if cnt >= 3
      end
    end

    return s

  end
end

p1 = Player.new("John")
p2 = Player.new("Bob")
p3 = Player.new("Marry")

g = Game.new(p1, p2, p3)
g.play_rounds(2)
