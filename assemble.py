"""
Assembler for Computer project.

Author: Radu Vasilescu
"""

import sys

DEBUG = '--debug' in sys.argv
VERILOG = '--verilog' in sys.argv

class Instruction:
    def __init__(self, instruction_string):
        self.parts = [part.replace(',', '') for part in instruction_string.split()]


# For a 16-bit value
def hex16(number):
    return f"{number:0{4}x}"


# For an 8-bit value
def hex8(number):
    return f"{number:0{2}x}"


# For a 4-bit value
def hex4(number):
    return f"{number:0{1}x}"


# Names of the registers mapped to their numbers
# (name : string) -> (number : int)
reg_names = {
    '$0': 0,        # Invariant: always = 0x00

    # General-purpose
    '$1':   1,
    '$2':   2,
    '$3':   3,
    '$4':   4,
    '$5':   5,
    '$6':   6,
    '$7':   7,

    # System/internal
    '$8':   8,      # Undefined/inconsistent behavior
    '$cmp': 9,      # Compare result

    # Stack
    '$sp':  10,     # Stack pointer
    '$sf':  11,     # Stack frame

    '$pc':  12,     # Program counter
}

# Encodings of the opcodes
# (opcode : string) -> (encoding : str[4-bit hex, length = 1])
opcodes = {
    'nop':      hex4(0),
    'mov':      hex4(1),
    'li':       hex4(2),
    'add':      hex4(3),
    'addi':     hex4(4),
    'neg':      hex4(5),
    'lw':       hex4(6),
    'sw':       hex4(7),
    'syscall':  hex4(8),
    'j':        hex4(9),
    'ja':       hex4(10),
    'cmp':      hex4(11),
    'jeq':      hex4(12),
    'jlt':      hex4(13),
    'jgt':      hex4(14),
    'jne':      hex4(15),
}


if sys.argv[1][sys.argv[1].find('.'):] != '.asm':
    print('Error: Unsupported file type. Must be ".asm"')
    sys.exit(1)

program_name = sys.argv[1][:sys.argv[1].find('.')]

in_file = open(sys.argv[1])

# Read into lines[]
source_lines = []

for line in in_file.readlines():
    line = line.strip()

    if line.startswith('#') or len(line) < 2:
        continue    # Is a comment or empty line; don't add that line.

    # If the line has a comment, disregard everything past that
    comment_start = line.find('#')
    if comment_start is not -1:
        line = line[:comment_start] # letters up to comment_start (not including the '#')

    source_lines.append(line.strip())

in_file.close()


# Now, turn them into a list of instructions.
instructions = []

for line in source_lines:
    instr = Instruction(line)
    instructions.append(instr)


# Ok, let's create our (output) ROM dictionary and the label table

# Working/temp version of the rom
# (address : hex string) -> (encoded_command : hex string)
rom = { }

current_address = 0

# Label jump table
# Mapping (label_name : string) -> (target_address : hex string)
labels = { }

for instr_number, instr in enumerate(instructions):
    # Is it a label?
    if instr.parts[0].startswith('_'):
        labels[instr.parts[0][:instr.parts[0].find(':')]] = hex8(current_address)
        #del instructions[instr_number]      # Never need to keep labels
    elif instr.parts[0].startswith('.'):
        # It's an assembler macro!
        print('Not yet implemented: ' + instr.parts[0])
        # TODO
    else:
        rom[hex8(current_address)] = instr.parts
        current_address += 1


if DEBUG == True:
    # Testing only: Print them all out!
    print('ROM: ')
    for address, value in rom.items():
        print(address + ': ' + str(value))

    print('\nLabels: ')
    for label, target in labels.items():
        print(label + ' -> ' + target)


# Okay, time to actually assemble!
out_rom = { }
for address in rom.keys():
    out_rom[address] = ""

for address, parts in rom.items():

    opcode = parts[0]
    arg1 = None
    arg2 = None

    if len(parts) > 1:
        arg1 = parts[1]

    if len(parts) > 2:
        arg2 = parts[2]

    if opcode == 'nop':
        out_rom[address] = opcodes['nop'] + hex4(0) + hex4(0) + hex4(0)

    elif opcode == 'mov':
        src = reg_names[arg1]
        target = reg_names[arg2]

        out_rom[address] = opcodes['mov'] + hex4(src) + hex4(target) + hex4(0b0000)

    elif opcode == 'li':
        target = reg_names[arg1]
        value = 0

        if arg2.startswith("'"):
            # Parse as character literal
            value = ord(arg2.replace("'", ""))
        else:
            # Parse as an integer
            value = int(arg2, 16)

        out_rom[address] = opcodes['li'] + hex4(target) + hex8(value)

    elif opcode == 'add':
        target = reg_names[arg1]
        source = reg_names[arg2]

        out_rom[address] = opcodes['add'] + hex4(target) + hex4(source) + hex4(0b0000)

    elif opcode == 'addi':
        target = reg_names[arg1]
        value = int(arg2, 16)

        out_rom[address] = opcodes['addi'] + hex4(target) + hex8(value)

    elif opcode == 'neg':
        target = reg_names[arg1]

        out_rom[address] = opcodes['neg'] + hex4(target) + hex4(0b0000) + hex4(0b0000)

    elif opcode == 'lw':
        target = reg_names[arg1]
        ptr = reg_names[arg2]

        out_rom[address] = opcodes['lw'] + hex4(target) + hex4(ptr) + hex4(0b0000)

    elif opcode == 'sw':
        target = reg_names[arg1]
        ptr = reg_names[arg2]

        out_rom[address] = opcodes['sw'] + hex4(target) + hex4(ptr) + hex4(0b0000)

    elif opcode == 'syscall':
        out_rom[address] = opcodes['syscall'] + hex4(0b0000) + hex4(0b0000) + hex4(0b0000)

    elif opcode == 'j':
        label_name = arg1
        label_addr = labels[label_name]

        out_rom[address] = opcodes['j'] + label_addr + hex4(0b0000)

    elif opcode == 'ja':
        target = reg_names[arg1]

        out_rom[address] = opcodes['ja'] + hex4(target) + hex4(0b0000) + hex4(0b0000)

    elif opcode == 'cmp':
        a = reg_names[arg1]
        b = reg_names[arg2]

        out_rom[address] = opcodes['cmp'] + hex4(a) + hex4(b) + hex4(0b0000)

    elif opcode == 'jeq':
        label_name = arg1
        label_addr = labels[label_name]

        out_rom[address] = opcodes['jeq'] + label_addr + hex4(0b0000)

    elif opcode == 'jlt':
        label_name = arg1
        label_addr = labels[label_name]

        out_rom[address] = opcodes['jlt'] + label_addr + hex4(0b0000)

    elif opcode == 'jgt':
        label_name = arg1
        label_addr = labels[label_name]

        out_rom[address] = opcodes['jgt'] + label_addr + hex4(0b0000)

    elif opcode == 'jne':
        label_name = arg1
        label_addr = labels[label_name]

        out_rom[address] = opcodes['jne'] + label_addr + hex4(0b0000)

    else:
        print('Unknown opcode: ' + opcode)
        sys.exit(1)


if DEBUG == True:
    print('\n\nResult: ')
    for address, value in out_rom.items():
        print(address + ': ' + str(value))


# Write assembled binary to output file either Logisim ROM format or Verilog format
out_file = open(program_name + '.rom', 'w')

if not VERILOG:
    out_file.write('v2.0 raw\n')    # Required header

    if DEBUG == True:
        print('\nOut File:')

        if not VERILOG:
            print('v2.0 raw')

counter = 0
current_line = ''
words_output = 0

for binary in out_rom.values():
    if VERILOG:
        current_line += binary + ' '  
        words_output += 1
    else:
        current_line += binary + ' '

    counter += 1

    if counter == 8:
        current_line.strip()

        if VERILOG:
            out_file.write(current_line)
        else:
            out_file.write(current_line + '\n')

        if DEBUG == True:
            print(current_line)

        current_line = ''

        counter = 0

current_line.strip()

if VERILOG:
    out_file.write(current_line)

    # Fill the rest of the space up to 256 words
    if words_output < 256:
        for _ in range(256 - words_output + 1):
            out_file.write('0000 ')
else:
    out_file.write(current_line + '\n')

if DEBUG == True:
    print(current_line)

out_file.close()