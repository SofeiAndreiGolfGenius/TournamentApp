class ValidScoreValidator <ActiveModel::Validator
  def validate(record)
    if record.player1_score && record.player2_score
      if record.player1_score == record.player2_score
        record.errors.add('Can not be a draw')
      end
    end
  end
end
