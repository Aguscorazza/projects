import random
import itertools

beating_move = {'R': 'P', 'P': 'S', 'S': 'R'}


class RandomPredictor:
    @staticmethod
    def predict():
        return random.choice(['R', 'P', 'S'])


class MarkovChainPredictor:
    def __init__(self, order, decay_factor=1.0, smoothing_parameter=1.0):
        self.smoothing_parameter = smoothing_parameter
        self.decay_factor = decay_factor
        self.transition_matrix = {}
        self.order = order

    def update_matrix(self, history):
        if len(history) < self.order + 1:
            return  # Not enough history to update

        state = tuple(history[-self.order - 1:-1])
        move = history[-1]

        if state not in self.transition_matrix:
            self.transition_matrix[state] = {'R': {'count': 0, 'weight': 1.0},
                                             'P': {'count': 0, 'weight': 1.0},
                                             'S': {'count': 0, 'weight': 1.0}}

        self.transition_matrix[state][move]['count'] += 1

        # Update weights based on decay factor
        for action in self.transition_matrix[state]:
            self.transition_matrix[state][action]['weight'] *= self.decay_factor

        self.transition_matrix[state][move]['weight'] += 1.0

    def predict(self, history):
        if len(history) < self.order:
            return random.choice(['R', 'P', 'S'])  # Random move if not enough history

        state = tuple(history[-self.order:])

        if state in self.transition_matrix:
            total_weighted_transitions = sum(
                self.transition_matrix[state][action]['weight'] for action in self.transition_matrix[state])
            weighted_probs = {
                move: (self.transition_matrix[state][move]['count'] + self.smoothing_parameter) /
                      (total_weighted_transitions + 3 * self.smoothing_parameter)
                for move in self.transition_matrix[state]
            }
            predicted_move = max(weighted_probs, key=weighted_probs.get)
            return beating_move[predicted_move]
        else:
            return random.choice(['R', 'P', 'S'])  # Random move if no information for the current state


if __name__ == "__main__":
    # Example usage
    order = 2  # You can experiment with different orders
    markov_chain = MarkovChainPredictor(order)
    history = []

    # Simulate some moves and update the Markov chain
    moves = ['R', 'P', 'S', 'R', 'P', 'S']
    for move in moves:
        markov_chain.update_matrix(history)
        history.append(move)

    # Predict the next move
    next_move = markov_chain.predict(history)
    print(f"Predicted next move: {next_move}")
