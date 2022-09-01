# frozen_string_literal: true

class ValidScoreValidator < ActiveModel::Validator
  def validate(record)
    return unless record.player1_score && record.player2_score && (record.player1_score == record.player2_score)

    record.errors.add('Can not be a draw')
  end
end
