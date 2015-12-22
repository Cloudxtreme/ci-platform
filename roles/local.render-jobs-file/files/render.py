#!/usr/bin/python2.7
import os

# Rename `jobs.groovy.j2` to `jobs.groovy` if the former exists.

if os.access("jobs.groovy.j2", os.R_OK):
    with open('jobs.groovy.j2', 'r') as j:
        content = j.read()
    with open('jobs.groovy', 'w') as out_file:
        out_file.write(content)
