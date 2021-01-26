module GameEvent where

import Cards

type Score = Int

-- event sourcing
-- event: comes from the domain
-- events should tell the complete story
-- happened in the past vs. commands
-- it's ok for the events to be redundant
{-
data GameEvent =
      CardDealt Player Card
    | PlayerWon Player Score
    | CardPutOnTrick Player Card -- Trick
    | TrickPickedUp Player Trick Score
    | PlayerReceivedScore Score
    | RoundOver -- redundant with TrickPickedUp
    | PlayerTurnChanged Player -- redundant, but helpful
-}
data GameEvent =
    HandDealt Player Hand
  | PlayerTurnChanged Player
  | LegalCardPlayed Player Card
  | TrickTaken Player Trick
  | IllegalCardPlayed Player Card
  | GameEnded Player
  deriving Show

data GameCommand =
      PlayCard Player Card
    | DealHands PlayerHands
    deriving Show