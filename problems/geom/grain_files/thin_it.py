import random

position_file_lines = open("maximal_sample_bf-4802.txt").readlines()

new_position_file = open("coarsened_positions.txt", 'w')

kept_lines = random.sample(position_file_lines, 400)

new_position_file.writelines(kept_lines)
