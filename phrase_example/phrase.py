# Phrase: Good Code
#===========================================================
fruit = ['apple', 'pear', 'banana'] 
print random.sample(fruit, 2 )
# print random.sample(fruit)

# Phrase: Lack Of Closure WorkAround
#===========================================================

# clean but not `closed' in independent binding environment.
# means, share scope with two(a and b) function, and could be
# accessed other via counter.count.
def counter():
    counter.count = 0
    def c():
        counter.count += 1
        return counter.count
    return c

a = counter()
b = counter()
print a()
print "===="
print b()

# >> 1
# >> ====
# >> 2

# Phrase: Genka Shoukyaku
#===========================================================
def teigaku(shutoku_kakaku, taiyou_nensu):
    shoukyaku_ritsu_table = { 4: 0.25, 5: 0.20 }
    shoukyaku_ritsu = shoukyaku_ritsu_table[taiyou_nensu]
    zanzon_kakaku = shutoku_kakaku * 0.10
    answer = (shutoku_kakaku - zanzon_kakaku ) * shoukyaku_ritsu
    return answer

pc1 = { "shutoku_kakaku": 500000, "taiyou_nensu": 5 }
zan = pc1['shutoku_kakaku'] - teigaku(**pc1)
zan = pc1['shutoku_kakaku']

# print 500000 * 0.05

gengaku  = teigaku(**pc1)
print "gengaku = ", gengaku

while True:
    zan = zan - gengaku
    if zan <  pc1['shutoku_kakaku'] * 0.05: break
    print zan

# Phrase: Logging
#===========================================================
import logging
import sys

LEVELS = {'debug': logging.DEBUG,
          'info': logging.INFO,
          'warning': logging.WARNING,
          'error': logging.ERROR,
          'critical': logging.CRITICAL}

if len(sys.argv) > 1:
    level_name = sys.argv[1]
    level = LEVELS.get(level_name, logging.NOTSET)
    logging.basicConfig(level=level)

logging.debug('This is a debug message')
logging.info('This is an info message')
logging.warning('This is a warning message')
logging.error('This is an error message')
logging.critical('This is a critical error message')

# Phrase: List slice
#===========================================================
lis =  [ 1,2,3,4,5 ]
print lis

print "## zero_to_one ##"
zero_to_one = slice(0,1)
print lis[0:1]
print lis[zero_to_one]

print "## zero_to_last ##"
zero_to_last = slice(0,-1)
print lis[0:-1]
print lis[zero_to_last]

print "### two_to_end ###"
two_to_end = slice(2,None)
print lis[2:]
print lis[two_to_end]

print "### start_to_three ###"
start_to_three = slice(None, 3)
print lis[:3]
print lis[start_to_three]

'''
### Result ####
[1, 2, 3, 4, 5]
## zero_to_one ##
[1]
[1]
## zero_to_last ##
[1, 2, 3, 4]
[1, 2, 3, 4]
### two_to_end ###
[3, 4, 5]
[3, 4, 5]
### start_to_three ###
[1, 2, 3]
[1, 2, 3]
'''

