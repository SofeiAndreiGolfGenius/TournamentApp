# frozen_string_literal: true

module TournamentsHelper
  def tournament_organizer?(tournament, user)
    tournament.organizer_id == user.id
  end

  def round_name(number_of_matches_in_round)
    case number_of_matches_in_round
    when 1
      'Final'
    when 2
      'Semifinals'
    when 4
      'Quarterfinals'
    when 8
      'Eighth-finals'
    when 16
      '16th-finals'
    when 32
      '32th-finals'
    end
  end

  def initialize_matches
    puts @tournament.sport
    @randomized_participants = @tournament.sport == 'golf' ? @tournament.users.shuffle : @tournament.teams.shuffle
    nr_games_in_first_round = 2**(@tournament.nr_of_rounds - 1)
    nr_games_in_total = 2**@tournament.nr_of_rounds - 1
    (0..nr_games_in_first_round - 1).each do |i|
      player1_id = @randomized_participants[i].id
      adversary_id = i + nr_games_in_first_round
      player2_id = adversary_id < @randomized_participants.size ? @randomized_participants[adversary_id].id : nil
      if player2_id.nil?
        @tournament.matches.create!(player1_id: player1_id, player2_id: player2_id, winner_id: player1_id)
      else
        @tournament.matches.create!(player1_id: player1_id, player2_id: player2_id)
      end
    end
    (nr_games_in_first_round..nr_games_in_total - 1).each do
      @tournament.matches.create!
    end
  end

  def get_matches_from_round(round_number)
    nr_rounds = @tournament.nr_of_rounds
    start_interval = 0
    (nr_rounds - round_number + 2..nr_rounds).each do |j|
      start_interval += 2**(j - 1)
    end
    end_interval = start_interval + 2**(nr_rounds - round_number) - 1
    @tournament.matches[start_interval..end_interval]
  end
end
