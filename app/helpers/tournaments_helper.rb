# frozen_string_literal: true

module TournamentsHelper
  def tournament_organizer?(tournament, user)
    tournament.organizer_id == user.id
  end

  def round_name(matches_in_round)
    Constants::ROUND_NAME[matches_in_round.to_s]
  end

  def nr_of_rounds
    nr_participants = @tournament.team_sport ? @tournament.teams.size : @tournament.users.size
    log2_integer = Math.log2(nr_participants).to_i
    Math.log2(nr_participants) == log2_integer ? log2_integer : log2_integer + 1
  end

  def start_tournament
    @tournament.update(started: true, round: 1, nr_of_rounds: nr_of_rounds)
    @randomized_participants = take_participants.shuffle
    (1..@tournament.nr_of_rounds).each do |round|
      nr_games_in_round = 2**(@tournament.nr_of_rounds - round)
      if round == 1
        (0..nr_games_in_round - 1).each do |i|
          player1_id = @randomized_participants[i].id
          adversary_id = i + nr_games_in_round
          player2_id = adversary_id < @randomized_participants.size ? @randomized_participants[adversary_id].id : nil
          if player2_id.nil?
            @tournament.matches.create!(player1_id: player1_id, player2_id: player2_id, winner_id: player1_id,
                                        sport: @tournament.sport, team_sport: @tournament.team_sport, in_round: round)
          else
            @tournament.matches.create!(player1_id: player1_id, player2_id: player2_id,
                                        sport: @tournament.sport, team_sport: @tournament.team_sport, in_round: round)
          end
        end
      else
        (0..nr_games_in_round - 1).each do
          @tournament.matches.create!(sport: @tournament.sport, team_sport: @tournament.team_sport, in_round: round)
        end
      end
    end
  end

  def get_matches_from_round(round_number)
    @tournament.matches.where(in_round: round_number)
  end

  def declare_winner
    @tournament.update_attribute(:winner_id, @tournament.matches.last.winner_id)
    @message = "Congratulations #{tournament_winner.name} !!!"
  end

  def tournament_winner
    if !@tournament.team_sport?
      User.find_by(id: @tournament.matches.last.winner_id)
    else
      Team.find_by(id: @tournament.matches.last.winner_id)
    end
  end

  def take_participants
    if @tournament.team_sport?
      @tournament.teams.paginate(page: params[:page])
    else
      @tournament.users.paginate(page: params[:page])
    end
  end
end
