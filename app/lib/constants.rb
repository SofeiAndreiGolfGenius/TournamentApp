# frozen_string_literal: true

class Constants
  MESSAGES = {
    not_logged_in: 'Please log in',
    login_success: 'Logged in as ',
    login_fail: 'Wrong password or email',

    score_success_by_user: 'Score declared successfully, waiting for tournament organizer to approve',
    score_success_by_organizer: 'Score declared successfully',
    match_draw: 'Can not be a draw!',
    score_declared: 'Score has already been declared',

    join_request_sent: 'Request sent, wait for a team member to accept you',
    invite_sent: 'Invite sent, wait for the user to respond',
    user_already_joined_your_team: 'User already joined your team',
    user_already_joined_another_team: 'User already joined another team',
    you_already_joined: 'You already joined this team',
    you_do_not_have_a_team: "You don't have a team to invite to",
    you_already_have_a_team: 'You already have a team',
    user_already_has_a_team: 'User already has a team',

    team_create_success: 'Team created successfully',
    team_delete_success: 'Deleted team successfully',
    team_not_found: 'Team not found',

    update_success: 'Changes saved successfully',

    user_create_success: 'User registered successfully',
    user_delete_success: 'Deleted user successfully',
    user_not_found: 'User not found',
    not_team_leader: 'Only the team leader can join tournaments',

    tournament_full: 'Sorry, the tournament is full',
    tournament_started: 'Sorry, the tournament has already started',

    tournament_create_success: 'Tournament created successfully',
    tournament_delete_success: 'Deleted tournament successfully',
    tournament_not_found: 'Tournament not found',

    tournament_not_enough_players: 'Not enough participants to start the tournament',
    have_not_joined_tournament: "You did not join the tournament, so you can't leave from it",
    winner_has_been_deleted: 'The winner has been deleted :(',
    start_tournament_message: 'Tournament started, good luck everyone!',

    can_only_answer_requests_for_you: 'You can only answer to friend requests that are sent to you!',
    can_only_retract_your_friend_requests: 'You can only retract your own friend requests',
    user_already_sent_you_request: 'User already sent you a friend request',
    you_are_already_friends: 'You are already friends',
    friendship_create_success: 'You are now friends!',
    friendship_delete_success: 'User unfriended!',
    can_only_delete_your_friendships: 'You can only delete your friendships!',

    message_create_failed: 'Failed to send message',
    message_delete_success: 'Message deleted!',
    can_only_delete_your_messages: 'Can only delete your messages!'

  }.freeze

  ROUND_NAME = {
    '1' => 'Final',
    '2' => 'Semifinals',
    '4' => 'Quarterfinals',
    '8' => 'Eighth-finals',
    '16' => '16th-finals',
    '32' => '32th-finals'
  }.freeze
end
