import random
from enum import IntEnum
from RPS_model import RandomPredictor, MarkovChainPredictor

class Action(IntEnum):
    Rock = 1
    Paper = 2
    Scissors = 3


def get_user_selection():
    choices = [f"{action.name}[{action.value}]" for action in Action]
    selection = int(input(f"Enter a choice ({', '.join(choices)}): "))
    action = Action(selection)
    return action


def get_computer_selection():
    selection = random.randint(1, len(Action))
    action = Action(selection)
    return action


def check_rps_result(user_action, computer_action):
    """
    Determines the result of the RPS round.
    :param user_action: Action
    :param computer_action: Action
    :return: 0 - AI won, 1 - Player won, 2 - Tie
    """
    #print(user_action, computer_action)
    if user_action == computer_action:
        print(f"Both players selected {user_action.name}. It's a tie!")
        return 2
    elif user_action == Action.Rock:
        if computer_action == Action.Scissors:
            print("Rock smashes scissors! You win!")
            return 1
        else:
            print("Paper covers rock! You lose.")
            return 0
    elif user_action == Action.Paper:
        if computer_action == Action.Rock:
            print("Paper covers rock! You win!")
            return 1
        else:
            print("Scissors cuts paper! You lose.")
            return 0
    elif user_action == Action.Scissors:
        if computer_action == Action.Paper:
            print("Scissors cuts paper! You win!")
            return 1
        else:
            print("Rock smashes scissors! You lose.")
            return 0


if __name__ == "__main__":
    while True:
        try:
            user_action = get_user_selection()
        except ValueError as e:
            range_str = f"[0, {len(Action) - 1}]"
            print(f"Invalid selection. Enter a value in range {range_str}")
            continue

        computer_action = get_computer_selection()
        check_rps_result(user_action, computer_action)

        play_again = input("Play again? (y/n): ")
        if play_again.lower() != "y":
            break
