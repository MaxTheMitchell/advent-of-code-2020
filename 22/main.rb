def input
  File.new("input.txt").read
end

def parsed_input
  input.split("\n\n")
end

def make_deck(input)
  input.split("\n")[1..].map(&:to_i)
end

def play_game(deck_1, deck_2)
  return deck_1 if deck_2 == []
  return deck_2 if deck_1 == []
  if deck_1[0] > deck_2[0]
    play_game(deck_1[1..] + [deck_1[0], deck_2[0]], deck_2[1..])
  else
    play_game(deck_1[1..], deck_2[1..] + [deck_2[0], deck_1[0]])
  end
end

def play_game_recersive(deck_1, deck_2, rounds = [])
  return deck_1 if deck_2 == [] or rounds.include?([deck_1, deck_2])
  return deck_2 if deck_1 == []
  if player_1_win?(deck_1, deck_2)
    play_game_recersive(deck_1[1..] + [deck_1[0], deck_2[0]], deck_2[1..], rounds << [deck_1, deck_2])
  else
    play_game_recersive(deck_1[1..], deck_2[1..] + [deck_2[0], deck_1[0]], rounds << [deck_1, deck_2])
  end
end

def sub_game_player_1_win?(deck_1, deck_2, rounds = [])
  return true if deck_2 == [] or rounds.include?([deck_1, deck_2])
  return false if deck_1 == []
  if player_1_win?(deck_1, deck_2)
    sub_game_player_1_win?(deck_1[1..] + [deck_1[0], deck_2[0]], deck_2[1..], rounds << [deck_1, deck_2])
  else
    sub_game_player_1_win?(deck_1[1..], deck_2[1..] + [deck_2[0], deck_1[0]], rounds << [deck_1, deck_2])
  end
end

def player_1_win?(deck_1, deck_2)
  if deck_1[0] < deck_1.length and deck_2[0] < deck_2.length
    sub_game_player_1_win?(deck_1[1..deck_1[0]], deck_2[1..deck_2[0]])
  else
    deck_1[0] > deck_2[0]
  end
end

def solve_silver
  deck_1 = make_deck(parsed_input[0])
  deck_2 = make_deck(parsed_input[1])
  play_game(deck_1, deck_2).reverse.each_with_index.sum { |v, i| (i + 1) * v }
end

def solve_gold
  deck_1 = make_deck(parsed_input[0])
  deck_2 = make_deck(parsed_input[1])
  play_game_recersive(deck_1, deck_2).reverse.each_with_index.sum { |v, i| (i + 1) * v }
end

puts solve_silver
puts solve_gold
