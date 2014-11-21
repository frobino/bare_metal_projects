# Initializing Stack and PC
monitor reg r13 = (0x00400000)
monitor reg pc = (0x00400004)

#break ResetHandler
break main
continue
