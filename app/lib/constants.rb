# frozen_string_literal: true

class Constants
  MESSAGES = {
    'NotLoggedIn' => 'Please log in',
    'LoginSuccess' => 'Logged in as ',
    'LoginFail' => 'Wrong password or email',

    'ScoreSuccessByUser' => 'Score declared successfully, waiting for tournament organizer to approve',
    'ScoreSuccessByOrganizer' => 'Score declared successfully',
    'MatchDraw' => 'Can not be a draw!',
    'ScoreDeclared' => 'Score has already been declared',

    'JoinRequestSent' => 'Request sent, wait for a team member to accept you',
    'InviteSent' => 'Invite sent, wait for the user to respond',
    'UserAlreadyJoinedYourTeam' => 'User already joined your team',
    'UserAlreadyJoinedAnotherTeam' => 'User already joined another team',
    'YouAlreadyJoined' => 'You already joined this team',

    'TeamCreateSuccess' => 'Team created successfully',
    'TeamDeleteSuccess' => 'Deleted team successfully',
    'TeamNotFound' => 'Team not found',

    'UpdateSuccess' => 'Changes saved successfully',

    'UserCreateSuccess' => 'User registered successfully',
    'UserDeleteSuccess' => 'Deleted user successfully',
    'UserNotFound' => 'User not found',
    'NotTeamLeader' => 'Only the team leader can join tournaments',

    'TournamentFull' => 'Sorry, the tournament is full',
    'TournamentStarted' => 'Sorry, the tournament has already started',
    'TournamentCreateSuccess' => 'Tournament created successfully',
    'TournamentDeleteSuccess' => 'Deleted tournament successfully',
    'TournamentNotEnoughPlayers' => 'Not enough participants to start the tournament',
    'WinnerHasBeenDeleted' => 'The winner has been deleted :(',
    'StartTournamentMessage' => 'Tournament started, good luck everyone!'
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
