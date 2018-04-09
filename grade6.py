#! /usr/bin/python3

#################################################
# author: Ammaar Muhammad Iqbal                 #
# run "chmod 700 grade6 && ./grade6 -h" for CLI #
#################################################

import subprocess
import argparse

parser = argparse.ArgumentParser(
    description='''This script grades homework 6 assigned by 
    Professor Louis Steinberg for CS314 Rutgers University Spring 
    2018. You must have python3, racket cli, and swipl cli installed 
    to run this script.'''
)
parser.add_argument('-s', '--scheme-file', help='Path to the scheme file')
parser.add_argument('-p', '--prolog-file', help='Path to the prolog file')
parser.add_argument(
    '-o', '--output-file',
    help='Path to the file where grade results should be saved\nDefaults to result.txt'
)
args = parser.parse_args()

schemeFile = args.scheme_file
prologFile = args.prolog_file
resultFile = 'result.txt'
if args.output_file:
    resultFile = args.output_file

schemeProblems = ['I', 'II']
prologProblems = ['III', 'IV', 'V', 'VI']

grade = 0
result = open(resultFile, mode='w')

class Problem:
    maxPoints = 0
    def __init__(self, number, answerFunction):
        self.number = number
        self.answerFunction = answerFunction
        self.tests = []
        self.maxPoints = 0
        self.grade = 0
    def addTest(self, query, correctAnswer, points, answerFunction=False):
        self.tests.append({
            'query': query,
            'correctAnswer': correctAnswer,
            'points': points,
            'answerFunction': answerFunction
        })
        self.maxPoints += points
        Problem.maxPoints += points

def schemeFileAnswer(query):
    ret = subprocess.check_output([
        'racket',
        '-I',
        'r5rs/init',
        '-f',
        schemeFile,
        '-e',
        query
    ], universal_newlines=True, timeout=5)
    return ret.strip()

def prologFileAnswer(query):
    ret = subprocess.check_output([
        'swipl', '-g', query, '-g', 'halt.', prologFile
    ], universal_newlines=True, timeout=5)
    return ret.strip()

def manualAnswer(query):
    while True:
        ret = input(query + ' (y/n): ')
        if ret in ['y', 'Y']:
            return True
        elif ret in ['n', 'N']:
            return False
        else:
            print('Answer with y (yes) or n (no)')

def printTest(problemNumber, test, points, testNumber, answerFunction):
    print('Grading problem', problemNumber, 'test', testNumber)
    global grade
    query = test['query']
    correctAnswer = test['correctAnswer']
    result.write('Problem ' + str(problemNumber) + ' Test ' + str(testNumber) + '\n')
    result.write('Query: ' + query + '\n')
    try:
        studentAnswer = answerFunction(query)
    except subprocess.CalledProcessError:
        studentAnswer = 'Error running query'
    except subprocess.TimeoutExpired:
        studentAnswer = 'Infinite loop'
    result.write('Your answer: ' + str(studentAnswer) + '\n')
    result.write('Correct answer: ' + str(correctAnswer) + '\n')
    ret = False
    if studentAnswer == correctAnswer:
        result.write('PASS +' + str(points) + '\n')
        grade += points
        ret = True
    else:
        result.write('FAIL\n')
    print('Problem', problemNumber, 'test', testNumber, 'graded')
    return ret

def printProblem(problem):
    for testIndex,test in enumerate(problem.tests):
        answerFunction = problem.answerFunction
        if test['answerFunction']:
            answerFunction = test['answerFunction']
        if printTest(problem.number, test, test['points'], testIndex + 1, answerFunction):
            problem.grade += test['points']
        result.write('\n')

def printProblems(problems):
    for problem in problems:
        if problem.number in schemeProblems and not schemeFile:
            print ('Problem', problem.number, 'not graded, no scheme file')
        elif problem.number in prologProblems and not prologFile:
            print ('Problem', problem.number, 'not graded, no prolog file')
        elif problem.number == 'II' and not manualAnswer("Is tribonacci and all its helper functions tail recursive?"):
            print('Problem II not graded, not tail recursive')
        else:
            printProblem(problem)
            result.write('Problem ' + str(problem.number) + ' grade: ' + str(problem.grade) + '/' + str(problem.maxPoints) + '\n\n')
            result.write('=====================================\n\n')

problems = [None] * 6

problems[0] = Problem('I', schemeFileAnswer)
problems[0].addTest("(firstNon0 0 0 1)", '1', 2.5)
problems[0].addTest("(firstNon0 0 2 1)", '2', 2.5)
problems[0].addTest("(firstNon0 3 0 1)", '3', 2.5)
problems[0].addTest("(firstNon0 0 (firstNon0 'a 0 1) 0)", 'a', 3.5)
problems[0].addTest("(firstNon0 (+ 3 -3) (- 2 5) 0)", '-3', 3)
problems[0].addTest("(firstNon0 0 (+ 8 -8) 0)", '0', 3)

problems[1] = Problem('II', schemeFileAnswer)
problems[1].addTest("(tribonacci 0)", '0', 2)
problems[1].addTest("(tribonacci 1)", '0', 2)
problems[1].addTest("(tribonacci 2)", '1', 2)
problems[1].addTest("(tribonacci 3)", '1', 3)
problems[1].addTest("(tribonacci 4)", '2', 3)
problems[1].addTest("(tribonacci 8)", '24', 5)

problems[2] = Problem('III', manualAnswer)
problems[2].addTest('Is Joe in the toy department?', True, 2.5)
problems[2].addTest('Do people in a department report to the head of that department?', True, 2.5)
problems[2].addTest('Is Sam the head of the toy department?', True, 2.5)
problems[2].addTest("Is everyone's salary less than the salary of the person they report to?", True, 2.5)
problems[2].addTest("Can it be infered that Joe's salary is less than Sam's salary?", True, 5)

problems[3] = Problem('IV', prologFileAnswer)
problems[3].addTest("trib(0,X), print(X).", '0', 2)
problems[3].addTest("trib(1,X), print(X).", '0', 2)
problems[3].addTest("trib(2,X), print(X).", '1', 2)
problems[3].addTest("trib(3,X), print(X).", '1', 3)
problems[3].addTest("trib(4,X), print(X).", '2', 3)
problems[3].addTest("trib(8,X), print(X).", '24', 5)

problems[4] = Problem('V', prologFileAnswer)
problems[4].addTest("echo([dog,cat],X), print(X).", '[dog,dog,cat,cat]', 3.2)
problems[4].addTest("echo([dog,snake,cat],X), print(X).", '[dog,dog,snake,snake,cat,cat]', 4)
problems[4].addTest("echo(X,[dog,dog,cat,cat]), print(X).", '[dog,cat]', 3)
problems[4].addTest("echo([cookie],X), print(X).", '[cookie,cookie]', 4)
problems[4].addTest("echo([],X), print(X).", '[]', 3)

problems[5] = Problem('VI', prologFileAnswer)
problems[5].addTest("suppressEchos([dog, dog, cat, cow, cow, cow],X), print(X).", '[dog,cat,cow]', 3.3)
problems[5].addTest("suppressEchos([dog,cat,cow],X), print(X).", '[dog,cat,cow]', 3.5)
problems[5].addTest("suppressEchos([dog,dog,dog,dog,cat],X), print(X).", '[dog,cat]', 3.5)
problems[5].addTest("suppressEchos([clock,clock,clock,clock,clock,clock],X), print(X).", '[clock]', 3.5)
problems[5].addTest("suppressEchos([],X), print(X).", '[]', 3)

printProblems(problems)

for problem in problems:
    result.write('Problem ' + str(problem.number) + ' grade: ' + str(problem.grade) + '/' + str(problem.maxPoints) + '\n')

result.write('\nTotal grade: ' + str(grade) + '/' + str(Problem.maxPoints) + '\n')
result.write('\nAmmaar Muhammad Iqbal\n')
result.write('ammaar.iqbal@rutgers.edu\n')

result.close()

print()
print('Done. Saved to', resultFile)
print()
print('Ammaar Muhammad Iqbal')
print('ammaar.iqbal@rutgers.edu')